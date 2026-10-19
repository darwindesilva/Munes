using UnityEngine;
using UnityEngine.Audio;

// scatters glowing chimes over the inside of the planet
// when the ball hits one it plays a note from the chord the music is on
public class ChimeField : MonoBehaviour
{
    public Transform sphereCenter;
    public ChunityMusicBridge music;
    public AudioMixerGroup sfxGroup;
    public AudioClip bellClip; // empty = generated bell

    [Header("Layout")]
    public int chimeCount = 40;
    public float hoverHeight = 3f;
    public float chimeSize = 2.5f;
    public int seed = 7; // 0 = different every play

    void Start()
    {
        if (bellClip == null) bellClip = SynthClips.Bell();
        StartCoroutine(SpawnLater());
    }

    // wait a bit so the terrain collider exists
    System.Collections.IEnumerator SpawnLater()
    {
        yield return new WaitForSeconds(0.5f);
        Spawn();
    }

    void Spawn()
    {
        if (seed != 0) Random.InitState(seed);
        Vector3 center = sphereCenter != null ? sphereCenter.position : Vector3.zero;

        int made = 0;
        int tries = 0;
        while (made < chimeCount && tries < chimeCount * 5)
        {
            tries++;
            Vector3 dir = Random.onUnitSphere;

            // shoot from the middle out to the inside of the shell
            Vector3 origin = center + dir * 100f;
            if (!Physics.Raycast(origin, dir, out RaycastHit hit, 700f, ~0, QueryTriggerInteraction.Ignore)) continue;
            if (hit.collider.GetComponent<MeshCollider>() == null) continue;

            MakeChime(hit.point + hit.normal * hoverHeight);
            made++;
        }
    }

    void MakeChime(Vector3 pos)
    {
        GameObject go = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        go.name = "Chime";
        go.transform.SetParent(transform);
        go.transform.position = pos;
        go.transform.localScale = Vector3.one * chimeSize;

        var col = go.GetComponent<SphereCollider>();
        col.isTrigger = true;
        col.radius = 0.8f;

        Color color = Color.HSVToRGB(Random.value, 0.5f, 1f);
        var rend = go.GetComponent<Renderer>();
        rend.material.color = color;

        var src = go.AddComponent<AudioSource>();
        src.clip = bellClip;
        src.playOnAwake = false;
        src.spatialBlend = 1f;
        src.rolloffMode = AudioRolloffMode.Logarithmic;
        src.minDistance = 15f;
        src.maxDistance = 150f;
        if (sfxGroup != null) src.outputAudioMixerGroup = sfxGroup;

        go.AddComponent<ChimeTrigger>().Setup(this, src, rend, color);
    }

    public void PlayChime(AudioSource src, float speed)
    {
        int midi = PickNote(speed);
        src.pitch = Mathf.Pow(2f, (midi - SynthClips.BellMidi) / 12f);
        src.volume = Mathf.Lerp(0.5f, 1f, Mathf.InverseLerp(0f, 30f, speed));
        src.Play();
    }

    int PickNote(float speed)
    {
        int midi = 60;

        ChordEntry chord = music != null ? ChordInfo.Get(music.CurrentChordIdx) : null;
        if (chord != null && chord.midi.Length > 0)
            midi = chord.midi[Random.Range(0, chord.midi.Length)];

        // going fast moves it up an octave
        if (speed > 20f) midi += 12;

        // audio source pitch tops out at 3
        return Mathf.Min(midi, 78);
    }
}
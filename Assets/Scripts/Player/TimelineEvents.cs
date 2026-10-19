using System.Collections;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.Playables;

// put this on the same object as the PlayableDirector and a Signal Receiver
// the signal reactions call the public methods below
public class TimelineEvents : MonoBehaviour
{
    public PlayableDirector director;
    public ChunityMusicBridge music;
    public Light flashLight;

    [Header("Audio")]
    public AudioMixer mixer;
    public AudioMixerGroup sfxGroup;
    public AudioClip stingerClip; // empty = generated riser
    public string musicVolume = "MusicVol";

    public KeyCode replayKey = KeyCode.Y;

    private AudioSource stinger;
    private float baseIntensity;

    void Start()
    {
        stinger = gameObject.AddComponent<AudioSource>();
        stinger.playOnAwake = false;
        stinger.spatialBlend = 0f;
        if (sfxGroup != null) stinger.outputAudioMixerGroup = sfxGroup;
        stinger.clip = stingerClip != null ? stingerClip : SynthClips.Riser();

        if (flashLight != null) baseIntensity = flashLight.intensity;
    }

    void Update()
    {
        if (director != null && Input.GetKeyDown(replayKey))
        {
            director.time = 0;
            director.Play();
        }
    }

    // signal methods

    public void ChordChange()
    {
        if (music != null) music.ForceChordChange();
    }

    public void LightPulse()
    {
        if (flashLight != null) StartCoroutine(Pulse());
    }

    public void Stinger()
    {
        stinger.Play();
    }

    public void MusicDip()
    {
        if (mixer != null) StartCoroutine(Dip());
    }

    IEnumerator Pulse()
    {
        float t = 0f;
        while (t < 1f)
        {
            t += Time.deltaTime * 1.2f;
            flashLight.intensity = Mathf.Lerp(baseIntensity * 3f, baseIntensity, t);
            yield return null;
        }
        flashLight.intensity = baseIntensity;
    }

    // music drops for a moment then comes back
    IEnumerator Dip()
    {
        float t = 0f;
        while (t < 1f)
        {
            t += Time.deltaTime * 3f;
            mixer.SetFloat(musicVolume, Mathf.Lerp(0f, -12f, t));
            yield return null;
        }

        yield return new WaitForSeconds(0.5f);

        t = 0f;
        while (t < 1f)
        {
            t += Time.deltaTime;
            mixer.SetFloat(musicVolume, Mathf.Lerp(-12f, 0f, t));
            yield return null;
        }
        mixer.SetFloat(musicVolume, 0f);
    }
}
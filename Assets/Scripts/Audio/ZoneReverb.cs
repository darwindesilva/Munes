using UnityEngine;

// puts a reverb zone in the middle of each biome, every zone gets its own preset
public class ZoneReverb : MonoBehaviour
{
    public Transform sphereCenter;
    public float placeRadius = 300f;
    public float minDistance = 120f;
    public float maxDistance = 260f;

    public AudioReverbPreset[] presets =
    {
        AudioReverbPreset.Cave,
        AudioReverbPreset.Mountains,
        AudioReverbPreset.Drugged,
        AudioReverbPreset.Hangar,
        AudioReverbPreset.Dizzy,
        AudioReverbPreset.Concerthall,
    };

    void Start()
    {
        var zm = ZoneManager.Instance;
        if (zm == null || zm.ZoneCenters == null) return;

        Vector3 center = sphereCenter != null ? sphereCenter.position : Vector3.zero;

        for (int i = 0; i < zm.ZoneCenters.Length; i++)
        {
            var go = new GameObject("ReverbZone " + i);
            go.transform.SetParent(transform);
            go.transform.position = center + zm.ZoneCenters[i] * placeRadius;

            var zone = go.AddComponent<AudioReverbZone>();
            zone.reverbPreset = presets[i % presets.Length];
            zone.minDistance = minDistance;
            zone.maxDistance = maxDistance;
        }
    }
}
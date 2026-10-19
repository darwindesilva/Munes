using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class ProceduralWind : MonoBehaviour
{
    [Header("Wind Character")]
    public float volume = 0.25f;
    public float duration = 20f;         // length of the generated loop
    public float lowpassCutoff = 300f;   // lower = darker, higher = airier
    public float pinkNoiseAmount = 0.7f; // 0 = white, 1 = pink-ish
    public int seed = 12345;

    [Header("3D Sound")]
    public float minDistance = 50f;
    public float maxDistance = 800f;

    void Start()
    {
        var src = GetComponent<AudioSource>();

        int sampleRate = AudioSettings.outputSampleRate;
        int sampleCount = Mathf.RoundToInt(sampleRate * duration);
        float[] samples = new float[sampleCount];

        // Two-pole lowpass on white noise → pink-ish wind
        float alpha = 1f - Mathf.Exp(-2f * Mathf.PI * lowpassCutoff / sampleRate);
        float state1 = 0f;
        float state2 = 0f;
        var rng = new System.Random(seed);

        for (int i = 0; i < sampleCount; i++)
        {
            float white = (float)(rng.NextDouble() * 2.0 - 1.0);
            state1 = state1 * (1f - alpha) + white * alpha;
            state2 = state2 * (1f - alpha) + state1 * alpha;
            samples[i] = Mathf.Lerp(white, state2, pinkNoiseAmount) * volume;
        }

        // Crossfade ends for a seamless loop
        int fadeSamples = Mathf.RoundToInt(sampleRate * 0.5f);
        for (int i = 0; i < fadeSamples; i++)
        {
            float t = i / (float)fadeSamples;
            samples[i] *= t;
            samples[sampleCount - 1 - i] *= t;
        }

        var clip = AudioClip.Create("ProceduralWind", sampleCount, 1, sampleRate, false);
        clip.SetData(samples, 0);

        src.clip = clip;
        src.loop = true;
        src.spatialBlend = 1f;                              // 3D
        src.minDistance = minDistance;
        src.maxDistance = maxDistance;
        src.rolloffMode = AudioRolloffMode.Logarithmic;
        src.volume = 1f;
        src.dopplerLevel = 0f;                              // ambient — no pitch shift
        src.Play();
    }
}
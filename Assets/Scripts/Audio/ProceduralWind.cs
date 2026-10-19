using UnityEngine;
using UnityEngine.Audio;

[RequireComponent(typeof(AudioSource))]
public class ProceduralWind : MonoBehaviour
{
    [Header("Wind Character")]
    public float volume = 0.25f;
    public float duration = 20f;         // length of the loop
    public float lowpassCutoff = 300f;   // lower = darker, higher = airier
    public float pinkNoiseAmount = 0.7f; // 0 = white, 1 = pink-ish
    public int seed = 12345;

    [Header("Mixer")]
    public AudioMixerGroup mixerGroup;

    [Header("3D Sound")]
    public float minDistance = 50f;
    public float maxDistance = 800f;

    void Start()
    {
        var src = GetComponent<AudioSource>();

        int sampleRate = AudioSettings.outputSampleRate;
        int sampleCount = Mathf.RoundToInt(sampleRate * duration);
        float[] samples = new float[sampleCount];

        // lowpass the white noise twice to get wind
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

        // fade the ends so the loop doesn't click
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
        if (mixerGroup != null) src.outputAudioMixerGroup = mixerGroup;
        src.loop = true;
        src.spatialBlend = 1f; // 3D
        src.minDistance = minDistance;
        src.maxDistance = maxDistance;
        src.rolloffMode = AudioRolloffMode.Logarithmic;
        src.volume = 1f;
        src.dopplerLevel = 0f; // no pitch shift
        src.Play();
    }
}
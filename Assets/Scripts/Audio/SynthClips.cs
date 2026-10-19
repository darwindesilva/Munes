using UnityEngine;

// makes simple sounds in code so the scene works before real samples are added
// put your own clips in the inspector fields to replace them
public static class SynthClips
{
    const int Rate = 44100;

    // the bell is recorded at this note, chimes change the pitch from here
    public const int BellMidi = 60;

    static AudioClip Make(string name, float[] data)
    {
        var clip = AudioClip.Create(name, data.Length, 1, Rate, false);
        clip.SetData(data, 0);
        return clip;
    }

    public static AudioClip Thump()
    {
        float length = 0.35f;
        float[] d = new float[(int)(Rate * length)];
        float phase = 0f;
        for (int i = 0; i < d.Length; i++)
        {
            float t = i / (float)Rate;
            float freq = 45f + 100f * Mathf.Exp(-t * 18f);
            phase += 2f * Mathf.PI * freq / Rate;
            float s = Mathf.Sin(phase) * Mathf.Exp(-t * 10f);
            if (t < 0.01f) s += (Random.value * 2f - 1f) * 0.3f * (1f - t / 0.01f);
            d[i] = s * 0.9f;
        }
        return Make("Thump", d);
    }

    public static AudioClip Slam()
    {
        float length = 0.8f;
        float[] d = new float[(int)(Rate * length)];
        float phase = 0f;
        float noise = 0f;
        for (int i = 0; i < d.Length; i++)
        {
            float t = i / (float)Rate;
            float freq = 30f + 160f * Mathf.Exp(-t * 12f);
            phase += 2f * Mathf.PI * freq / Rate;
            noise += 0.15f * ((Random.value * 2f - 1f) - noise);
            float s = Mathf.Sin(phase) * Mathf.Exp(-t * 5f) + noise * Mathf.Exp(-t * 14f) * 1.5f;
            d[i] = Mathf.Clamp(s, -1f, 1f);
        }
        return Make("Slam", d);
    }

    public static AudioClip Whoosh()
    {
        float length = 0.7f;
        float[] d = new float[(int)(Rate * length)];
        float state = 0f;
        for (int i = 0; i < d.Length; i++)
        {
            float t = i / (float)d.Length;
            float env = Mathf.Sin(Mathf.PI * t);
            env *= env;
            float alpha = Mathf.Lerp(0.02f, 0.3f, env);
            state += alpha * ((Random.value * 2f - 1f) - state);
            d[i] = state * env * 2.5f;
        }
        return Make("Whoosh", d);
    }

    // low rumble that loops
    public static AudioClip RollLoop()
    {
        float length = 2f;
        float[] d = new float[(int)(Rate * length)];
        float a = 0f;
        float b = 0f;
        for (int i = 0; i < d.Length; i++)
        {
            a += 0.04f * ((Random.value * 2f - 1f) - a);
            b += 0.2f * (a - b);
            d[i] = b * 6f;
        }

        // fade the ends so it doesn't click
        int fade = Rate / 10;
        for (int i = 0; i < fade; i++)
        {
            float f = i / (float)fade;
            d[i] *= f;
            d[d.Length - 1 - i] *= f;
        }
        return Make("RollLoop", d);
    }

    public static AudioClip Bell()
    {
        float length = 3f;
        float baseFreq = 261.63f;
        float[] ratios = { 1f, 2f, 2.76f, 5.4f };
        float[] amps = { 1f, 0.5f, 0.35f, 0.15f };
        float[] decays = { 2.2f, 3f, 4.5f, 7f };

        float[] d = new float[(int)(Rate * length)];
        for (int i = 0; i < d.Length; i++)
        {
            float t = i / (float)Rate;
            float s = 0f;
            for (int p = 0; p < ratios.Length; p++)
                s += Mathf.Sin(2f * Mathf.PI * baseFreq * ratios[p] * t) * amps[p] * Mathf.Exp(-t * decays[p]);
            d[i] = s * 0.35f;
        }
        return Make("Bell", d);
    }

    public static AudioClip Riser()
    {
        float length = 2.5f;
        float[] d = new float[(int)(Rate * length)];
        float phase = 0f;
        float noise = 0f;
        for (int i = 0; i < d.Length; i++)
        {
            float t = i / (float)d.Length;
            float freq = Mathf.Lerp(100f, 800f, t * t);
            phase += 2f * Mathf.PI * freq / Rate;
            noise += Mathf.Lerp(0.02f, 0.4f, t) * ((Random.value * 2f - 1f) - noise);
            float s = (Mathf.Sin(phase) * 0.5f + noise * 1.5f) * t * t;
            d[i] = s;
        }
        return Make("Riser", d);
    }
}
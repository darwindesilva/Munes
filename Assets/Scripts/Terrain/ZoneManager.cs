using UnityEngine;

public class ZoneManager : MonoBehaviour
{
    public static ZoneManager Instance { get; private set; }

    [Header("Zones")]
    [Range(1, 16)] public int zoneCount = 6;
    [Tooltip("0 = randomize each play. Non-zero = deterministic layout.")]
    public int zoneSeed = 0;

    [Header("Zone Colors (must have >= zoneCount entries)")]
    public Color[] zoneColors = new Color[]
    {
        new Color(0.80f, 0.45f, 0.25f),  // rust
        new Color(0.55f, 0.60f, 0.65f),  // cool grey
        new Color(0.45f, 0.30f, 0.50f),  // purple
        new Color(0.76f, 0.70f, 0.50f),  // sand
        new Color(0.30f, 0.55f, 0.40f),  // teal
        new Color(0.85f, 0.35f, 0.35f),  // red
        new Color(0.65f, 0.65f, 0.30f),  // olive
        new Color(0.40f, 0.40f, 0.75f),  // blue
    };

    public Vector3[] ZoneCenters { get; private set; }

    void Awake()
    {
        if (Instance != null && Instance != this) { Destroy(gameObject); return; }
        Instance = this;
        Regenerate();
    }

    [ContextMenu("Regenerate")]
    public void Regenerate()
    {
        int seed = zoneSeed != 0 ? zoneSeed : System.Environment.TickCount;
        var rng = new System.Random(seed);

        ZoneCenters = new Vector3[zoneCount];
        if (zoneCount == 1)
        {
            ZoneCenters[0] = Vector3.up;
            return;
        }

        float goldenAngle = Mathf.PI * (3f - Mathf.Sqrt(5f));
        float yOffset = (float)rng.NextDouble() * 2f * Mathf.PI;

        for (int i = 0; i < zoneCount; i++)
        {
            float y = 1f - (i / (float)(zoneCount - 1)) * 2f;
            float radius = Mathf.Sqrt(Mathf.Max(0f, 1f - y * y));
            float theta = goldenAngle * i + yOffset;
            ZoneCenters[i] = new Vector3(Mathf.Cos(theta) * radius, y, Mathf.Sin(theta) * radius);
        }
    }

    // zone whose center is closest to this direction
    public int GetZoneForDirection(Vector3 radial)
    {
        if (ZoneCenters == null || ZoneCenters.Length == 0) return 0;
        int best = 0;
        float bestDot = -2f;
        for (int i = 0; i < ZoneCenters.Length; i++)
        {
            float d = Vector3.Dot(radial, ZoneCenters[i]);
            if (d > bestDot) { bestDot = d; best = i; }
        }
        return best;
    }

    public Color GetColor(int zone)
    {
        if (zoneColors == null || zoneColors.Length == 0) return Color.white;
        return zoneColors[zone % zoneColors.Length];
    }
}
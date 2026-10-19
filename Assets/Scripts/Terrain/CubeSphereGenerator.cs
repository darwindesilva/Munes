using UnityEngine;
using System.Collections.Generic;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer), typeof(MeshCollider))]
public class CubeSphereGenerator : MonoBehaviour
{
    [Header("Sphere Settings")]
    public float radius = 400f;
    [Range(2, 256)] public int resolution = 129;

    [Header("Dune Settings")]
    public float duneHeight = 200f;
    public float duneScale = 12f;
    [Tooltip("1 = totally smooth/round. 1.3 = subtle shaping. >2 = sharp again.")]
    [Range(1f, 3f)]
    public float duneSharpness = 1.0f;   // was 2–6; 1.0 = round dunes
    public int noiseOctaves = 5;
    public float noiseLacunarity = 2f;
    public float noisePersistence = 0.45f; // lower = smoother, rounder
    [Header("Biome Blend")]
    [Range(1f, 8f)] public float zoneBlendSharpness = 4f;

    [Header("Biome Colors (8 octants)")]
    [Tooltip("Index = (x+ ? 1 : 0) | (y+ ? 2 : 0) | (z+ ? 4 : 0)")]
    public Color[] biomeColors = new Color[8]
    {
        new Color(0.80f, 0.45f, 0.25f), // 0  ---  Rust
        new Color(0.55f, 0.60f, 0.65f), // 1  +--  Cool grey
        new Color(0.45f, 0.30f, 0.50f), // 2  -+-  Purple
        new Color(0.76f, 0.70f, 0.50f), // 3  ++-  Sand
        new Color(0.30f, 0.55f, 0.40f), // 4  --+  Teal
        new Color(0.85f, 0.35f, 0.35f), // 5  +-+  Red clay
        new Color(0.65f, 0.65f, 0.30f), // 6  -++  Olive
        new Color(0.40f, 0.40f, 0.75f), // 7  +++  Blue
    };

    [Header("Biome Blend")]
    [Tooltip("1 = very soft blend, 4+ = sharp octant borders")]
    [Range(1f, 8f)] public float biomeBlendSharpness = 2.5f;

    [Header("Baked Lighting")]
    [Tooltip("Floor brightness — valleys never go below this")]
    [Range(0f, 1f)] public float ambientLevel = 0.55f;
    [Tooltip("Extra brightness on flat ground (peaks/valleys get ambientLevel + this)")]
    [Range(0f, 1f)] public float lightContribution = 0.45f;

    private Mesh mesh;
    private List<Vector3> vertices;
    private List<int> triangles;
    private List<Color> colors;
    private List<Vector2> uvs;

    void Start() { Generate(); }

    [ContextMenu("Regenerate")]
    public void Generate()
    {
        EnsureBiomeArraySize();
        vertices = new List<Vector3>();
        triangles = new List<int>();
        colors = new List<Color>();
        uvs = new List<Vector2>();

        Vector3[] faceNormals = {
            Vector3.right, Vector3.left,
            Vector3.up, Vector3.down,
            Vector3.forward, Vector3.back
        };
        for (int f = 0; f < 6; f++) GenerateFace(faceNormals[f]);

        mesh = new Mesh();
        mesh.name = "CubeSphere";
        mesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32;
        mesh.SetVertices(vertices);
        mesh.SetTriangles(triangles, 0);
        mesh.SetUVs(0, uvs);
        mesh.RecalculateNormals();
        mesh.RecalculateBounds();

        // Bake lighting into vertex colors using the freshly-computed normals.
        Vector3[] normals = mesh.normals;
        Color[] baked = new Color[vertices.Count];
        for (int i = 0; i < vertices.Count; i++)
        {
            Vector3 radial = vertices[i].normalized;
            // Flatness: 1 on flat terrain, <1 on dune slopes.
            float flatness = Mathf.Abs(Vector3.Dot(normals[i], radial));
            float lightTerm = ambientLevel + lightContribution * flatness;
            Color c = colors[i];
            baked[i] = new Color(c.r * lightTerm, c.g * lightTerm, c.b * lightTerm, 1f);
        }
        mesh.SetColors(baked);

        GetComponent<MeshFilter>().mesh = mesh;
        GetComponent<MeshCollider>().sharedMesh = mesh;
    }

    void GenerateFace(Vector3 normal)
    {
        Vector3 axisA = new Vector3(normal.y, normal.z, normal.x);
        Vector3 axisB = Vector3.Cross(normal, axisA);
        int startIndex = vertices.Count;

        for (int y = 0; y < resolution; y++)
        {
            for (int x = 0; x < resolution; x++)
            {
                float u = (float)x / (resolution - 1);
                float v = (float)y / (resolution - 1);

                Vector3 pointOnCube = normal + axisA * (u * 2f - 1f) + axisB * (v * 2f - 1f);
                Vector3 pointOnSphere = pointOnCube.normalized;

                float height = SampleDuneHeight(pointOnSphere);
                Vector3 displaced = pointOnSphere * (radius - height);

                vertices.Add(displaced);
                colors.Add(GetBlendedBiomeColor(pointOnSphere));
                uvs.Add(new Vector2(u, v));
            }
        }

        for (int y = 0; y < resolution - 1; y++)
        {
            for (int x = 0; x < resolution - 1; x++)
            {
                int i = startIndex + y * resolution + x;
                // Inward-facing winding
                triangles.Add(i);
                triangles.Add(i + resolution);
                triangles.Add(i + resolution + 1);
                triangles.Add(i);
                triangles.Add(i + resolution + 1);
                triangles.Add(i + 1);
            }
        }
    }
    void EnsureBiomeArraySize()
    {
        if (biomeColors == null)
            biomeColors = new Color[8];

        if (biomeColors.Length == 8) return;

        Color[] defaults = new Color[8]
        {
        new Color(0.80f, 0.45f, 0.25f),
        new Color(0.55f, 0.60f, 0.65f),
        new Color(0.45f, 0.30f, 0.50f),
        new Color(0.76f, 0.70f, 0.50f),
        new Color(0.30f, 0.55f, 0.40f),
        new Color(0.85f, 0.35f, 0.35f),
        new Color(0.65f, 0.65f, 0.30f),
        new Color(0.40f, 0.40f, 0.75f),
        };

        Color[] resized = new Color[8];
        for (int i = 0; i < 8; i++)
            resized[i] = (i < biomeColors.Length) ? biomeColors[i] : defaults[i];

        biomeColors = resized;
    }

    /// <summary>
    /// Weighted blend of the 8 octant colors.
    /// On a boundary between 2-4 octants, all contributing colors mix smoothly.
    /// </summary>
    Color GetBlendedBiomeColor(Vector3 dir)
    {
        var zm = ZoneManager.Instance;
        if (zm == null || zm.ZoneCenters == null || zm.ZoneCenters.Length == 0)
            return Color.gray;

        Vector3 radial = dir.normalized;
        int n = zm.ZoneCenters.Length;
        float[] weights = new float[n];
        float total = 0f;

        for (int i = 0; i < n; i++)
        {
            // angular distance in radians
            float dot = Mathf.Clamp(Vector3.Dot(radial, zm.ZoneCenters[i]), -1f, 1f);
            float angle = Mathf.Acos(dot);
            float w = 1f / Mathf.Pow(angle + 0.02f, zoneBlendSharpness);
            weights[i] = w;
            total += w;
        }

        if (total <= 0f) return zm.GetColor(0);

        float r = 0f, g = 0f, b = 0f;
        for (int i = 0; i < n; i++)
        {
            float w = weights[i] / total;
            Color c = zm.GetColor(i);
            r += c.r * w;
            g += c.g * w;
            b += c.b * w;
        }
        return new Color(r, g, b, 1f);
    }

    float SampleDuneHeight(Vector3 p)
    {
        // Standard fractal Brownian motion — smooth, rolling hills.
        float sum = 0f;
        float amplitude = 1f;
        float frequency = duneScale;
        float totalAmplitude = 0f;

        for (int o = 0; o < noiseOctaves; o++)
        {
            float n = ValueNoise3D(
                p.x * frequency,
                p.y * frequency,
                p.z * frequency,
                1337 + o * 71);

            sum += n * amplitude;
            totalAmplitude += amplitude;
            amplitude *= noisePersistence;
            frequency *= noiseLacunarity;
        }

        float h = sum / totalAmplitude;   // in [0, 1], mean ≈ 0.5

        // Optional mild shaping — a SMALL power keeps things readable without
        // sharpening peaks. Set duneSharpness to 1.0 to disable entirely.
        h = Mathf.Pow(h, duneSharpness);

        // Fully uniform — no pole fade, no large-scale mask.
        return h * duneHeight;
    }

    // 3D value noise with trilinear interpolation.
    // This is what makes the noise wrap seamlessly around the whole sphere.
    float ValueNoise3D(float x, float y, float z, int seed)
    {
        int xi = Mathf.FloorToInt(x);
        int yi = Mathf.FloorToInt(y);
        int zi = Mathf.FloorToInt(z);
        float xf = x - xi;
        float yf = y - yi;
        float zf = z - zi;

        // Smoothstep for C1 continuity between cells
        float u = xf * xf * (3f - 2f * xf);
        float v = yf * yf * (3f - 2f * yf);
        float w = zf * zf * (3f - 2f * zf);

        float c000 = Hash(xi, yi, zi, seed);
        float c100 = Hash(xi + 1, yi, zi, seed);
        float c010 = Hash(xi, yi + 1, zi, seed);
        float c110 = Hash(xi + 1, yi + 1, zi, seed);
        float c001 = Hash(xi, yi, zi + 1, seed);
        float c101 = Hash(xi + 1, yi, zi + 1, seed);
        float c011 = Hash(xi, yi + 1, zi + 1, seed);
        float c111 = Hash(xi + 1, yi + 1, zi + 1, seed);

        float x00 = Mathf.Lerp(c000, c100, u);
        float x10 = Mathf.Lerp(c010, c110, u);
        float x01 = Mathf.Lerp(c001, c101, u);
        float x11 = Mathf.Lerp(c011, c111, u);

        float y0 = Mathf.Lerp(x00, x10, v);
        float y1 = Mathf.Lerp(x01, x11, v);

        return Mathf.Lerp(y0, y1, w);
    }

    // Deterministic hash → [0, 1]
    float Hash(int x, int y, int z, int seed)
    {
        unchecked
        {
            int h = x * 374761393 + y * 668265263 + z * 1274126177 + seed * 1442695041;
            h = (h ^ (h >> 13)) * 1274126177;
            h = h ^ (h >> 16);
            return (h & 0x7FFFFFFF) / (float)0x7FFFFFFF;
        }
    }

}
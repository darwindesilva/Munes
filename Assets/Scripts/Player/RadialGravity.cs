using UnityEngine;

public class RadialGravity : MonoBehaviour
{
    public static RadialGravity Instance { get; private set; }

    [Header("Gravity Settings")]
    public float gravityStrength = 9.81f;
    public Transform sphereCenter; // the SphereTerrain transform

    void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }

    // gravity at a position, points from the center out to the shell
    public Vector3 GetGravity(Vector3 worldPosition)
    {
        Vector3 fromCenter = worldPosition - sphereCenter.position;
        Vector3 direction = fromCenter.normalized;
        return direction * gravityStrength;
    }

    // local up at a position
    public Vector3 GetUp(Vector3 worldPosition)
    {
        return -GetGravity(worldPosition).normalized;
    }

}
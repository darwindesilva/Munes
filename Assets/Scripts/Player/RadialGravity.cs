using UnityEngine;

public class RadialGravity : MonoBehaviour
{
    public static RadialGravity Instance { get; private set; }

    public float gravityStrength = 9.81f;
    public Transform sphereCenter;

    void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }

    // gravity points away from the center
    public Vector3 GetGravity(Vector3 worldPosition)
    {
        Vector3 fromCenter = worldPosition - sphereCenter.position;
        return fromCenter.normalized * gravityStrength;
    }

    public Vector3 GetUp(Vector3 worldPosition)
    {
        return -GetGravity(worldPosition).normalized;
    }
}
using UnityEngine;

public class RadialGravity : MonoBehaviour
{
    public static RadialGravity Instance { get; private set; }

    [Header("Gravity Settings")]
    public float gravityStrength = 9.81f; // Adjustable: try 15 for snappier arcs
    public Transform sphereCenter; // Assign the SphereTerrain transform

    void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }

    /// <summary>
    /// Returns the gravity acceleration vector at a given world position.
    /// Direction: from center outward (toward the shell surface).
    /// </summary>
    public Vector3 GetGravity(Vector3 worldPosition)
    {
        Vector3 fromCenter = worldPosition - sphereCenter.position;
        Vector3 direction = fromCenter.normalized; // Points outward, toward shell
        return direction * gravityStrength;
    }

    /// <summary>
    /// Returns the local "up" vector at a given position (opposite of gravity).
    /// </summary>
    public Vector3 GetUp(Vector3 worldPosition)
    {
        return -GetGravity(worldPosition).normalized;
    }

}
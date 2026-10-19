using UnityEngine;

public class RadialGravity : MonoBehaviour
{
    public static RadialGravity Instance { get; private set; }

    [Header("Gravity Settings")]
    public float gravityStrength = 9.81f; //adjustable
    public Transform sphereCenter; //assign the SphereTerrain transform

    void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
    }

    //returns the gravity acceleration vector at a given world position. Direction is considered from center outward towards shell surface.
    public Vector3 GetGravity(Vector3 worldPosition)
    {
        Vector3 fromCenter = worldPosition - sphereCenter.position;
        Vector3 direction = fromCenter.normalized; //points outwards
        return direction * gravityStrength;
    }

    //returns the local "up" vector at a given position
    public Vector3 GetUp(Vector3 worldPosition)
    {
        return -GetGravity(worldPosition).normalized;
    }

}
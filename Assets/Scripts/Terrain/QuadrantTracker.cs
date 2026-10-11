using UnityEngine;

public class QuadrantTracker : MonoBehaviour
{
    public Transform sphereCenter;
    public int CurrentQuadrant { get; private set; }

    void Update()
    {
        Vector3 dir = (transform.position - sphereCenter.position).normalized;
        int q = 0;
        if (dir.x >= 0f) q |= 1;
        if (dir.y >= 0f) q |= 2;
        if (dir.z >= 0f) q |= 4;
        CurrentQuadrant = q;
    }
}
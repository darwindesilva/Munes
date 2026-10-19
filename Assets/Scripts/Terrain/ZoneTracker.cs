using UnityEngine;

public class ZoneTracker : MonoBehaviour
{
    public RadialGravity gravity;

    public int CurrentZone { get; private set; }
    public int PreviousZone { get; private set; }
    public bool JustChangedZone { get; private set; }

    private float changeCooldown;

    void Start()
    {
        if (gravity == null) gravity = RadialGravity.Instance;
        if (gravity != null && gravity.sphereCenter != null)
        {
            Vector3 radial = (transform.position - gravity.sphereCenter.position).normalized;
            CurrentZone = ZoneManager.Instance.GetZoneForDirection(radial);
            PreviousZone = CurrentZone;
        }
    }

    void Update()
    {
        if (ZoneManager.Instance == null || gravity == null || gravity.sphereCenter == null) return;

        Vector3 radial = (transform.position - gravity.sphereCenter.position).normalized;
        int z = ZoneManager.Instance.GetZoneForDirection(radial);

        if (z != CurrentZone && changeCooldown <= 0f)
        {
            PreviousZone = CurrentZone;
            CurrentZone = z;
            JustChangedZone = true;
            changeCooldown = 0.25f;   // small delay so it doesn't flicker on a border
        }
        else
        {
            JustChangedZone = false;
        }

        if (changeCooldown > 0f) changeCooldown -= Time.deltaTime;
    }
}
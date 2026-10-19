using UnityEngine;

[RequireComponent(typeof(ChuckSubInstance))]
public class ChunityMusicBridge : MonoBehaviour
{
    [Header("ChucK")]
    public string chuckScriptFile = "munes_music.ck";
    public float updateInterval = 0.05f; // 20 Hz

    [Header("Gameplay References")]
    public BallController ball;
    public ZoneTracker zoneTracker;
    public RadialGravity gravity;

    private ChuckSubInstance chuck;
    private float timer;

    // Cached strings (avoid GC in the hot path)
    private const string SPEED = "in_speed";
    private const string GROUNDED = "in_grounded";
    private const string TAKEOFF = "in_takeoff";
    private const string LANDED = "in_landed";
    private const string HEIGHT = "in_height";
    private const string TIME_TO_LAND = "in_timeToLand";
    private const string ZONE = "in_zone";

    void Start()
    {
        chuck = GetComponent<ChuckSubInstance>();
        chuck.RunFile(chuckScriptFile);
    }

    void Update()
    {
        if (chuck == null || ball == null) return;

        timer += Time.deltaTime;
        if (timer < updateInterval) return;
        timer = 0f;

        // --- Continuous inputs ---
        float speed = ball.GetComponent<Rigidbody>().linearVelocity.magnitude;
        float height = 0f;
        if (gravity != null && gravity.sphereCenter != null)
        {
            Vector3 gDir = (ball.transform.position - gravity.sphereCenter.position).normalized;
            if (Physics.Raycast(ball.transform.position, gDir, out RaycastHit hit, 1000f))
                height = Mathf.Max(0f, hit.distance - 1f);
        }

        int zone = zoneTracker != null ? zoneTracker.CurrentZone : 0;

        chuck.SetFloat(SPEED, speed);
        chuck.SetInt(GROUNDED, ball.IsGrounded ? 1 : 0);
        chuck.SetFloat(HEIGHT, height);
        chuck.SetFloat(TIME_TO_LAND, ball.PredictTimeToLand());
        chuck.SetInt(ZONE, zone);

        // --- One-shot events ---
        if (ball.JustTookOff)
        {
            chuck.SetInt(TAKEOFF, 1);
            Invoke(nameof(ResetTakeoff), 0.2f);
        }
        if (ball.JustLanded)
        {
            chuck.SetInt(LANDED, 1);
            Invoke(nameof(ResetLanded), 0.2f);
        }
    }

    void ResetTakeoff() => chuck.SetInt(TAKEOFF, 0);
    void ResetLanded() => chuck.SetInt(LANDED, 0);
}
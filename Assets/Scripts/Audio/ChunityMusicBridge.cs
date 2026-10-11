using UnityEngine;

[RequireComponent(typeof(ChuckSubInstance))]
public class ChunityMusicBridge : MonoBehaviour
{
    [Header("ChucK")]
    public string chuckScriptFile = "munes_music.ck";
    public float updateInterval = 0.05f; // 20 Hz — good balance

    [Header("Gameplay References")]
    public BallController ball;
    public QuadrantTracker quadrant;
    public RadialGravity gravity;

    private ChuckSubInstance chuck;
    private float timer;

    // Cached strings (avoid GC)
    private const string SPEED = "in_speed";
    private const string GROUNDED = "in_grounded";
    private const string TAKEOFF = "in_takeoff";
    private const string LANDED = "in_landed";
    private const string HEIGHT = "in_height";
    private const string TIME_TO_LAND = "in_timeToLand";
    private const string QUADRANT = "in_quadrant";

    void Start()
    {
        chuck = GetComponent<ChuckSubInstance>();
        chuck.RunFile(chuckScriptFile);
    }

    void Update()
    {
        timer += Time.deltaTime;
        if (timer < updateInterval) return;
        timer = 0f;

        // Continuous inputs
        float speed = ball != null ? ball.GetComponent<Rigidbody>().linearVelocity.magnitude : 0f;
        float height = 0f;
        if (gravity != null && gravity.sphereCenter != null)
            height = Vector3.Distance(ball.transform.position, gravity.sphereCenter.position) - 400f;

        chuck.SetFloat(SPEED, speed);
        chuck.SetInt(GROUNDED, ball.IsGrounded ? 1 : 0);
        chuck.SetFloat(HEIGHT, height);
        chuck.SetFloat(TIME_TO_LAND, ball.PredictTimeToLand());
        chuck.SetInt(QUADRANT, quadrant.CurrentQuadrant);

        // One-shot events — set to 1, then reset after a short delay
        if (ball.JustTookOff)
        {
            chuck.SetInt(TAKEOFF, 1);
            Invoke(nameof(ResetTakeoff), 0.1f);
        }
        if (ball.JustLanded)
        {
            chuck.SetInt(LANDED, 1);
            Invoke(nameof(ResetLanded), 0.1f);
        }
    }

    void ResetTakeoff() => chuck.SetInt(TAKEOFF, 0);
    void ResetLanded() => chuck.SetInt(LANDED, 0);
}
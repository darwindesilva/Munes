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

    // what the music is playing right now, read back from chuck
    public int CurrentChordIdx { get; private set; }
    public int CurrentNodeIdx { get; private set; }
    public int CurrentGraphIdx { get; private set; }

    private ChuckSubInstance chuck;
    private Rigidbody ballRb;
    private float timer;

    private const string SPEED = "in_speed";
    private const string GROUNDED = "in_grounded";
    private const string TAKEOFF = "in_takeoff";
    private const string LANDED = "in_landed";
    private const string HEIGHT = "in_height";
    private const string TIME_TO_LAND = "in_timeToLand";
    private const string ZONE = "in_zone";
    private const string FORCE_CHANGE = "in_forceChange";

    void Start()
    {
        chuck = GetComponent<ChuckSubInstance>();
        chuck.RunFile(chuckScriptFile);
        if (ball != null) ballRb = ball.GetComponent<Rigidbody>();
    }

    void Update()
    {
        if (chuck == null || ball == null) return;

        timer += Time.deltaTime;
        if (timer < updateInterval) return;
        timer = 0f;

        // continuous values
        float speed = ballRb.linearVelocity.magnitude;
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

        // one shot events
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

        // ask chuck what chord it is on
        chuck.GetInt("out_chordIdx", OnChordIdx);
        chuck.GetInt("out_nodeIdx", OnNodeIdx);
        chuck.GetInt("out_graphIdx", OnGraphIdx);
    }

    // makes the music move to the next chord, timeline uses this
    public void ForceChordChange()
    {
        if (chuck != null) chuck.SetInt(FORCE_CHANGE, 1);
    }

    void OnChordIdx(long val) { CurrentChordIdx = (int)val; }
    void OnNodeIdx(long val) { CurrentNodeIdx = (int)val; }
    void OnGraphIdx(long val) { CurrentGraphIdx = (int)val; }

    void ResetTakeoff() => chuck.SetInt(TAKEOFF, 0);
    void ResetLanded() => chuck.SetInt(LANDED, 0);
}
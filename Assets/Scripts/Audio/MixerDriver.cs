using UnityEngine;
using UnityEngine.Audio;

// moves the exposed mixer parameters with what the ball is doing
public class MixerDriver : MonoBehaviour
{
    public AudioMixer mixer;
    public BallController ball;
    public RadialGravity gravity;

    [Header("Exposed parameter names")]
    public string windVolume = "WindVol";
    public string musicCutoff = "MusicCutoff";
    public string sfxEchoWet = "SfxEchoWet";

    [Header("Ranges")]
    public float maxSpeed = 35f;
    public float maxHeight = 150f;

    private Rigidbody ballRb;
    private float windDb = -25f;
    private float cutoff = 4000f;
    private float echo;
    private bool warned;

    void Start()
    {
        if (ball != null) ballRb = ball.GetComponent<Rigidbody>();
    }

    void Update()
    {
        if (mixer == null || ball == null) return;

        float speed = ballRb.linearVelocity.magnitude;

        float height = 0f;
        if (gravity != null && gravity.sphereCenter != null)
        {
            Vector3 gDir = (ball.transform.position - gravity.sphereCenter.position).normalized;
            if (Physics.Raycast(ball.transform.position, gDir, out RaycastHit hit, 1000f))
                height = Mathf.Max(0f, hit.distance - 1f);
        }

        float speedT = Mathf.InverseLerp(0f, maxSpeed, speed);
        float heightT = Mathf.InverseLerp(0f, maxHeight, height);
        float k = Time.deltaTime * 3f;

        // faster is windier, higher up opens the music filter and adds echo
        windDb = Mathf.Lerp(windDb, Mathf.Lerp(-25f, 0f, speedT), k);
        cutoff = Mathf.Lerp(cutoff, Mathf.Lerp(4000f, 18000f, heightT), k);
        echo = Mathf.Lerp(echo, Mathf.Lerp(0f, 0.5f, heightT), k);

        bool ok = mixer.SetFloat(windVolume, windDb);
        ok &= mixer.SetFloat(musicCutoff, cutoff);
        ok &= mixer.SetFloat(sfxEchoWet, echo);

        if (!ok && !warned)
        {
            Debug.LogWarning("one of the mixer parameters isn't exposed, check the names");
            warned = true;
        }
    }
}
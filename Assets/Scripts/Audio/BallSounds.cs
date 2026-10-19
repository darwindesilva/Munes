using UnityEngine;
using UnityEngine.Audio;

[RequireComponent(typeof(Rigidbody))]
[RequireComponent(typeof(BallController))]
public class BallSounds : MonoBehaviour
{
    [Header("Clips (empty = generated ones)")]
    public AudioClip impactClip;
    public AudioClip rollClip;
    public AudioClip jumpClip;
    public AudioClip slamClip;

    [Header("Mixer")]
    public AudioMixerGroup sfxGroup;

    [Header("Tuning")]
    public float maxRollSpeed = 30f;
    public float minImpactSpeed = 3f;
    public float maxImpactSpeed = 40f;

    private BallController ball;
    private Rigidbody rb;
    private AudioSource rollSource;
    private AudioSource impactSource;
    private AudioSource airSource;
    private float rollVolume;

    void Start()
    {
        ball = GetComponent<BallController>();
        rb = GetComponent<Rigidbody>();

        if (impactClip == null) impactClip = SynthClips.Thump();
        if (rollClip == null) rollClip = SynthClips.RollLoop();
        if (jumpClip == null) jumpClip = SynthClips.Whoosh();
        if (slamClip == null) slamClip = SynthClips.Slam();

        rollSource = MakeSource();
        rollSource.clip = rollClip;
        rollSource.loop = true;
        rollSource.volume = 0f;
        rollSource.Play();

        impactSource = MakeSource();
        airSource = MakeSource();

        ball.TookOff += OnTakeoff;
        ball.Slammed += OnSlam;
    }

    void OnDestroy()
    {
        if (ball == null) return;
        ball.TookOff -= OnTakeoff;
        ball.Slammed -= OnSlam;
    }

    AudioSource MakeSource()
    {
        var src = gameObject.AddComponent<AudioSource>();
        src.playOnAwake = false;
        src.spatialBlend = 0f;
        if (sfxGroup != null) src.outputAudioMixerGroup = sfxGroup;
        return src;
    }

    void Update()
    {
        // rolling gets louder and higher with speed, only on the ground
        float speed = rb.linearVelocity.magnitude;
        float speedT = Mathf.InverseLerp(0f, maxRollSpeed, speed);
        float target = ball.IsGrounded ? Mathf.InverseLerp(1f, maxRollSpeed, speed) : 0f;

        rollVolume = Mathf.Lerp(rollVolume, target, Time.deltaTime * 8f);
        rollSource.volume = rollVolume * 0.8f;
        rollSource.pitch = Mathf.Lerp(0.6f, 1.8f, speedT);
    }

    void OnCollisionEnter(Collision c)
    {
        float impact = c.relativeVelocity.magnitude;
        if (impact < minImpactSpeed) return;

        // harder hit is louder and lower
        float amount = Mathf.InverseLerp(minImpactSpeed, maxImpactSpeed, impact);
        impactSource.pitch = Random.Range(0.9f, 1.1f) * Mathf.Lerp(1.2f, 0.7f, amount);
        impactSource.PlayOneShot(impactClip, Mathf.Lerp(0.2f, 1f, amount));
    }

    void OnTakeoff()
    {
        float speedT = Mathf.InverseLerp(0f, maxRollSpeed, rb.linearVelocity.magnitude);
        airSource.pitch = Random.Range(0.9f, 1.1f) * Mathf.Lerp(0.9f, 1.4f, speedT);
        airSource.PlayOneShot(jumpClip, 0.5f);
    }

    void OnSlam()
    {
        airSource.pitch = Random.Range(0.95f, 1.05f);
        airSource.PlayOneShot(slamClip, 1f);
    }
}
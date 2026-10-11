using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class BallController : MonoBehaviour
{
    [Header("Ground Movement")]
    public float moveForce = 25f;
    public float maxGroundSpeed = 30f;
    public float groundFriction = 2f;

    [Header("Air Control")]
    public float airStrafeAcceleration = 8f;
    public float airStrafeMaxSpeed = 25f;
    public float slamForce = 40f;

    [Header("Jump")]
    public float jumpForce = 12f;
    public float jumpCooldown = 0.3f;

    [Header("Ground Detection")]
    public float groundCheckDistance = 1.2f;
    public LayerMask groundLayer;

    private float justTookOffTimer;
    private float justLandedTimer;

    public bool IsGrounded => isGrounded;
    public bool JustTookOff => justTookOffTimer > 0f;
    public bool JustLanded => justLandedTimer > 0f;

    private Rigidbody rb;
    private RadialGravity gravity;
    private Vector3 gravityDir; // Direction of gravity (toward center)
    private Vector3 localUp;    // Opposite of gravity
    private bool isGrounded;
    private float lastJumpTime;

    // Input
    private float inputHorizontal;
    private float inputVertical;
    private bool jumpPressed;
    private bool slamPressed;

    // For Chunity
    public bool WasGroundedLastFrame { get; private set; }
    public float TimeSinceTakeoff { get; private set; }

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        gravity = RadialGravity.Instance;
        rb.useGravity = false;
        rb.constraints = RigidbodyConstraints.None; // Allow full rotation for rolling
    }

    void Update()
    {
        inputHorizontal = Input.GetAxisRaw("Horizontal");
        inputVertical = Input.GetAxisRaw("Vertical");
        jumpPressed = Input.GetKeyDown(KeyCode.Space);
        slamPressed = Input.GetKeyDown(KeyCode.LeftShift) || Input.GetKeyDown(KeyCode.RightShift);

        // Update gravity direction based on current position
        gravityDir = gravity.GetGravity(transform.position).normalized;
        localUp = -gravityDir;
    }

    void FixedUpdate()
    {
        // Apply custom gravity
        rb.AddForce(gravityDir * gravity.gravityStrength, ForceMode.Acceleration);

        // Ground check
        bool groundedNow = Physics.Raycast(
            transform.position,
            gravityDir,
            out RaycastHit hit,
            groundCheckDistance,
            groundLayer
        );

        WasGroundedLastFrame = isGrounded;
        isGrounded = groundedNow;

        if (isGrounded && !WasGroundedLastFrame)
        {
            justLandedTimer = 0.15f;
            OnLanded();
        }
        if (!isGrounded && WasGroundedLastFrame)
        {
            justTookOffTimer = 0.15f;
            OnTakeoff();
        }

        // Decrement timers
        if (justTookOffTimer > 0f) justTookOffTimer -= Time.fixedDeltaTime;
        if (justLandedTimer > 0f) justLandedTimer -= Time.fixedDeltaTime;

        if (isGrounded)
        {
            HandleGroundMovement(hit.normal);
        }
        else
        {
            HandleAirMovement();
        }

        // Jump
        if (jumpPressed && isGrounded && Time.time - lastJumpTime > jumpCooldown)
        {
            rb.AddForce(localUp * jumpForce, ForceMode.Impulse);
            lastJumpTime = Time.time;
        }

        // Slam
        if (slamPressed && !isGrounded)
        {
            Vector3 slamDir = Vector3.Slerp(gravityDir, Camera.main.transform.forward, 0.5f).normalized;
            rb.AddForce(slamDir * slamForce, ForceMode.Impulse);
        }
    }

    void HandleGroundMovement(Vector3 groundNormal)
    {
        // Project input onto the tangent plane of the surface
        Vector3 forward = Vector3.ProjectOnPlane(Camera.main.transform.forward, groundNormal).normalized;
        Vector3 right = Vector3.ProjectOnPlane(Camera.main.transform.right, groundNormal).normalized;

        Vector3 moveDir = (forward * inputVertical + right * inputHorizontal).normalized;

        // Apply movement force
        rb.AddForce(moveDir * moveForce, ForceMode.Force);

        // Ground friction (counteract horizontal velocity)
        Vector3 horizontalVel = Vector3.ProjectOnPlane(rb.linearVelocity, groundNormal);
        rb.AddForce(-horizontalVel * groundFriction, ForceMode.Force);

        // Speed cap
        if (rb.linearVelocity.magnitude > maxGroundSpeed)
        {
            rb.linearVelocity = rb.linearVelocity.normalized * maxGroundSpeed;
        }
    }

    void HandleAirMovement()
    {
        // Air strafe: accelerate in the direction of input, relative to camera
        Vector3 forward = Camera.main.transform.forward;
        Vector3 right = Camera.main.transform.right;
        Vector3 strafeDir = (forward * inputVertical + right * inputHorizontal).normalized;

        // Only accelerate if current speed is below cap
        if (rb.linearVelocity.magnitude < airStrafeMaxSpeed)
        {
            rb.AddForce(strafeDir * airStrafeAcceleration, ForceMode.Acceleration);
        }

        // No friction in air, but slight drag
        rb.AddForce(-rb.linearVelocity * 0.02f, ForceMode.Acceleration);

        TimeSinceTakeoff += Time.fixedDeltaTime;
    }

    void OnTakeoff()
    {
        TimeSinceTakeoff = 0f;
        // TODO: Notify Chunity — takeoff event
        Debug.Log("Takeoff");
    }

    void OnLanded()
    {
        // TODO: Notify Chunity — landing event
        Debug.Log($"Landed after {TimeSinceTakeoff:F2}s");
    }

    /// <summary>
    /// Estimated time until impact, for Chunity prediction.
    /// Uses simple ballistic approximation.
    /// </summary>
    public float PredictTimeToLand()
    {
        if (isGrounded) return 0f;
        if (gravity == null || gravity.sphereCenter == null) return -1f;

        Vector3 gDir = (transform.position - gravity.sphereCenter.position).normalized;

        float ballRadius = transform.localScale.x * 0.5f;
        if (!Physics.Raycast(transform.position, gDir, out RaycastHit hit, 1000f, groundLayer))
            return -1f; // no surface below us

        float distanceToSurface = hit.distance - ballRadius;
        if (distanceToSurface < 0.05f) return 0f;

        // Ballistic solve: d = v0*t + 0.5*a*t^2, where v0 is velocity along gravity
        float v0 = Vector3.Dot(rb.linearVelocity, gDir);
        float a = gravity.gravityStrength * 0.5f; // half of gravity
        float b = v0;
        float c = -distanceToSurface;

        float disc = b * b - 4f * a * c;
        if (disc < 0f) return -1f;

        float t = (-b + Mathf.Sqrt(disc)) / (2f * a);
        return t > 0f ? t : 0f;
    }
}
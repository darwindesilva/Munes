using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class BallController : MonoBehaviour
{
    [Header("Ground Movement")]
    public float moveForce = 25f;
    public float maxGroundSpeed = 35f;
    public float groundFriction = 0.6f;

    [Header("Air Control")]
    public float airStrafeAcceleration = 8f;
    public float airStrafeMaxSpeed = 25f;
    public float slamForce = 45f;

    [Header("Jump")]
    public float jumpForce = 20f;
    public float jumpCooldown = 0.3f;

    [Header("Ground Detection")]
    public float groundCheckDistance = 1.5f;
    public LayerMask groundLayer;

    [Header("Momentum Preservation")]
    [Range(0f, 1f)] public float landingMomentumPreserve = 0.5f;

    [Header("Debug")]
    public bool drawGizmos = true;

    private Rigidbody rb;
    private RadialGravity gravity;
    private Camera cam;

    private Vector3 gravityDir;
    private Vector3 localUp;
    private bool isGrounded;
    private float lastJumpTime;

    private float inputHorizontal;
    private float inputVertical;
    private bool jumpLatched;
    private bool slamLatched;

    private float justTookOffTimer;
    private float justLandedTimer;

    private RaycastHit lastGroundHit;
    private bool lastGroundedResult;

    private Vector3 preLandingVelocity;

    public bool IsGrounded => isGrounded;
    public bool JustTookOff => justTookOffTimer > 0f;
    public bool JustLanded => justLandedTimer > 0f;
    public bool LastGroundHitIsValid => lastGroundedResult;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        gravity = RadialGravity.Instance;
        cam = Camera.main;
        rb.useGravity = false;
        rb.constraints = RigidbodyConstraints.None;

        // Assign a low-friction Physic Material so Unity doesn't kill
        // tangential momentum on collision. Rolling is still visually
        // correct because the code applies forces along the surface.
        var col = GetComponent<Collider>();
        if (col != null)
        {
            var mat = new PhysicsMaterial("BallMaterial");
            mat.dynamicFriction = 0.05f;
            mat.staticFriction = 0.05f;
            mat.bounciness = 0f;
            mat.frictionCombine = PhysicsMaterialCombine.Minimum;
            mat.bounceCombine = PhysicsMaterialCombine.Minimum;
            col.material = mat;
        }

        if (gravity != null && gravity.sphereCenter != null)
        {
            gravityDir = (transform.position - gravity.sphereCenter.position).normalized;
            localUp = -gravityDir;
        }
    }

    void Update()
    {
        inputHorizontal = Input.GetAxisRaw("Horizontal");
        inputVertical = Input.GetAxisRaw("Vertical");

        if (Input.GetKeyDown(KeyCode.Space)) jumpLatched = true;
        if (Input.GetKeyDown(KeyCode.LeftShift) || Input.GetKeyDown(KeyCode.RightShift))
            slamLatched = true;

        if (cam == null) cam = Camera.main;

        if (gravity != null && gravity.sphereCenter != null)
        {
            gravityDir = (transform.position - gravity.sphereCenter.position).normalized;
            localUp = -gravityDir;
        }
    }

    void FixedUpdate()
    {
        if (gravity == null || cam == null) return;

        bool jumpNow = jumpLatched;
        bool slamNow = slamLatched;
        jumpLatched = false;
        slamLatched = false;

        //store velocity before ground collision for landing preservation
        preLandingVelocity = rb.linearVelocity;

        rb.AddForce(gravityDir * gravity.gravityStrength, ForceMode.Acceleration);

        float ballRadius = transform.localScale.x * 0.5f;
        bool groundedNow = Physics.SphereCast(
            transform.position,
            ballRadius * 0.95f,
            gravityDir,
            out RaycastHit hit,
            groundCheckDistance,
            groundLayer,
            QueryTriggerInteraction.Ignore
        );
        lastGroundHit = hit;
        lastGroundedResult = groundedNow;

        bool wasGrounded = isGrounded;
        isGrounded = groundedNow;

        if (isGrounded && !wasGrounded)
        {
            justLandedTimer = 0.15f;

            //momentum preservation: restore a fraction of the tangential velocity that was lost during the collision response.
            Vector3 preTangential = Vector3.ProjectOnPlane(preLandingVelocity, gravityDir);
            Vector3 postTangential = Vector3.ProjectOnPlane(rb.linearVelocity, gravityDir);
            float lostSpeed = preTangential.magnitude - postTangential.magnitude;
            if (lostSpeed > 0.5f && preTangential.magnitude > 1f)
            {
                Vector3 restoreDir = preTangential.normalized;
                rb.linearVelocity += restoreDir * lostSpeed * landingMomentumPreserve;
            }

            OnLanded();
        }
        if (!isGrounded && wasGrounded)
        {
            justTookOffTimer = 0.15f;
            OnTakeoff();
        }

        if (justTookOffTimer > 0f) justTookOffTimer -= Time.fixedDeltaTime;
        if (justLandedTimer > 0f) justLandedTimer -= Time.fixedDeltaTime;

        if (isGrounded) HandleGroundMovement(hit.normal);
        else HandleAirMovement();

        if (jumpNow && isGrounded && Time.time - lastJumpTime > jumpCooldown)
        {
            rb.AddForce(localUp * jumpForce, ForceMode.Impulse);
            lastJumpTime = Time.time;
        }

        //90% vertical slam
        if (slamNow && !isGrounded)
        {
            Vector3 camFwd = cam.transform.forward;
            Vector3 tangent = Vector3.ProjectOnPlane(camFwd, -gravityDir).normalized;
            Vector3 slamDir = (tangent * 0.1f + gravityDir * 0.9f).normalized;

            rb.AddForce(slamDir * slamForce, ForceMode.Impulse);

            float alignedSpeed = Vector3.Dot(rb.linearVelocity, slamDir);
            if (alignedSpeed > 0f)
            {
                rb.linearVelocity += slamDir * alignedSpeed * 0.3f;
            }
        }
    }

    void HandleGroundMovement(Vector3 groundNormal)
    {
        Vector3 forward = Vector3.ProjectOnPlane(cam.transform.forward, groundNormal).normalized;
        Vector3 right = Vector3.ProjectOnPlane(cam.transform.right, groundNormal).normalized;
        Vector3 moveDir = forward * inputVertical + right * inputHorizontal;
        if (moveDir.sqrMagnitude > 1f) moveDir.Normalize();

        rb.AddForce(moveDir * moveForce, ForceMode.Force);

        Vector3 horizontalVel = Vector3.ProjectOnPlane(rb.linearVelocity, groundNormal);
        rb.AddForce(-horizontalVel * groundFriction, ForceMode.Force);

        if (rb.linearVelocity.magnitude > maxGroundSpeed)
        {
            rb.linearVelocity = rb.linearVelocity.normalized * maxGroundSpeed;
        }
    }

    void HandleAirMovement()
    {
        Vector3 forward = cam.transform.forward;
        Vector3 right = cam.transform.right;
        Vector3 strafeDir = forward * inputVertical + right * inputHorizontal;
        if (strafeDir.sqrMagnitude > 1f) strafeDir.Normalize();

        if (rb.linearVelocity.magnitude < airStrafeMaxSpeed)
        {
            rb.AddForce(strafeDir * airStrafeAcceleration, ForceMode.Acceleration);
        }

        rb.AddForce(-rb.linearVelocity * 0.02f, ForceMode.Acceleration);
    }

    void OnTakeoff() { Debug.Log("Takeoff"); }
    void OnLanded() { Debug.Log("Landed"); }

    public float PredictTimeToLand()
    {
        if (isGrounded) return 0f;
        if (gravity == null || gravity.sphereCenter == null) return -1f;

        Vector3 gDir = (transform.position - gravity.sphereCenter.position).normalized;
        float ballRadius = transform.localScale.x * 0.5f;

        if (!Physics.Raycast(transform.position, gDir, out RaycastHit hit, 1000f, groundLayer))
            return -1f;

        float distanceToSurface = hit.distance - ballRadius;
        if (distanceToSurface < 0.05f) return 0f;

        float v0 = Vector3.Dot(rb.linearVelocity, gDir);
        float a = gravity.gravityStrength * 0.5f;
        float b = v0;
        float c = -distanceToSurface;

        float disc = b * b - 4f * a * c;
        if (disc < 0f) return -1f;

        float t = (-b + Mathf.Sqrt(disc)) / (2f * a);
        return t > 0f ? t : 0f;
    }

    void OnDrawGizmos()
    {
        if (!drawGizmos) return;

        Vector3 gDir = (RadialGravity.Instance != null && RadialGravity.Instance.sphereCenter != null)
            ? (transform.position - RadialGravity.Instance.sphereCenter.position).normalized
            : Vector3.down;
        float ballRadius = transform.localScale.x * 0.5f;

        Gizmos.color = new Color(0.2f, 0.6f, 1f, 0.5f);
        Gizmos.DrawWireSphere(transform.position, ballRadius);

        Gizmos.color = lastGroundedResult ? Color.green : Color.red;
        Gizmos.DrawLine(transform.position,
                        transform.position + gDir * (groundCheckDistance + ballRadius));
        Gizmos.DrawWireSphere(
            transform.position + gDir * (groundCheckDistance + ballRadius),
            ballRadius * 0.95f);

        if (lastGroundedResult)
        {
            Gizmos.color = Color.yellow;
            Gizmos.DrawSphere(lastGroundHit.point, 0.15f);
            Gizmos.color = Color.white;
            Gizmos.DrawLine(lastGroundHit.point, lastGroundHit.point + lastGroundHit.normal * 1.5f);
        }
    }
}
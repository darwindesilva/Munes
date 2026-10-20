using UnityEngine;

public class OrbitCamera : MonoBehaviour
{
    public Transform target;
    public Renderer ballRenderer;

    [Header("Third Person")]
    public float thirdPersonDistance = 8f;
    public float thirdPersonHeight = 2f;
    public float turnSpeed = 5f;
    public float minSpeedForDirection = 0.5f;

    [Header("First Person")]
    public float fpForwardOffset = 0.4f;

    [Header("Rotation")]
    public float mouseSensitivity = 3f;
    public float minPitch = -89.9f;
    public float maxPitch = 89.9f;

    [Header("Smoothing")]
    public float positionSmoothTime = 0.12f;
    public float rotationSmoothSpeed = 15f;
    public float upSmoothTime = 0.25f;

    [Header("Collision")]
    public float collisionRadius = 0.3f;
    public LayerMask collisionLayers;

    [Header("Mode Toggle")]
    public KeyCode toggleKey = KeyCode.T;
    public bool startInFirstPerson = false;

    private RadialGravity gravity;
    private Rigidbody ballRb;
    private float yaw;
    private float pitch = 10f;
    private Vector3 velocity;
    private Vector3 currentUp;
    private Vector3 smoothedFwd = Vector3.zero;
    private bool firstPerson;
    private bool initialized = false;

    void Start()
    {
        gravity = RadialGravity.Instance;
        ballRb = target != null ? target.GetComponent<Rigidbody>() : null;
        currentUp = gravity.GetUp(target.position);
        firstPerson = startInFirstPerson;
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        ApplyModeVisuals();
    }

    void Update()
    {
        if (Input.GetKeyDown(toggleKey))
        {
            firstPerson = !firstPerson;
            ApplyModeVisuals();
            initialized = false;

            if (firstPerson && smoothedFwd.sqrMagnitude > 0.01f)
            {
                // enter first person looking in the ball's direction
                Vector3 localFwd = Vector3.ProjectOnPlane(Vector3.forward, currentUp).normalized;
                yaw = Vector3.SignedAngle(localFwd, smoothedFwd, currentUp);
                pitch = 0f;
            }
        }
    }

    void ApplyModeVisuals()
    {
        if (ballRenderer != null)
            ballRenderer.enabled = !firstPerson;
    }

    void LateUpdate()
    {
        if (target == null) return;

        Vector3 targetUp = gravity.GetUp(target.position);
        if (targetUp.sqrMagnitude > 0.0001f)
        {
            if (initialized)
                currentUp = Vector3.Slerp(currentUp, targetUp, Time.deltaTime / upSmoothTime);
            else
                currentUp = targetUp;
        }

        Vector3 localFwd = Vector3.ProjectOnPlane(Vector3.forward, currentUp);
        if (localFwd.sqrMagnitude < 0.01f)
            localFwd = Vector3.ProjectOnPlane(Vector3.right, currentUp);
        localFwd.Normalize();
        Vector3 localRight = Vector3.Cross(currentUp, localFwd).normalized;

        if (firstPerson)
        {
            yaw += Input.GetAxis("Mouse X") * mouseSensitivity;
            pitch -= Input.GetAxis("Mouse Y") * mouseSensitivity;
            pitch = Mathf.Clamp(pitch, minPitch, maxPitch);

            Quaternion yawRot = Quaternion.AngleAxis(yaw, currentUp);
            Vector3 yawedFwd = yawRot * localFwd;
            Vector3 yawedRight = yawRot * localRight;
            Quaternion pitchRot = Quaternion.AngleAxis(pitch, yawedRight);
            Vector3 lookDir = pitchRot * yawedFwd;

            transform.position = target.position + lookDir * fpForwardOffset;
            transform.rotation = Quaternion.LookRotation(lookDir, currentUp);
            initialized = true;
        }
        else
        {
            // direction the ball is rolling (tangential velocity)
            Vector3 targetDir = smoothedFwd;
            if (ballRb != null)
            {
                Vector3 tangVel = Vector3.ProjectOnPlane(ballRb.linearVelocity, currentUp);
                if (tangVel.magnitude > minSpeedForDirection)
                    targetDir = tangVel.normalized;
            }

            // initialize or smoothly turn toward new direction
            if (smoothedFwd.sqrMagnitude < 0.01f || targetDir.sqrMagnitude < 0.01f)
            {
                smoothedFwd = localFwd;
            }
            else
            {
                smoothedFwd = Vector3.Slerp(smoothedFwd, targetDir, Time.deltaTime * turnSpeed).normalized;
            }

            // camera behind the ball along that direction
            Vector3 desiredPos = target.position
                               - smoothedFwd * thirdPersonDistance
                               + currentUp * thirdPersonHeight;

            // pull in if terrain blocks the camera
            Vector3 dir = desiredPos - target.position;
            if (Physics.SphereCast(
                    target.position, collisionRadius, dir.normalized,
                    out RaycastHit hit, dir.magnitude,
                    collisionLayers, QueryTriggerInteraction.Ignore))
            {
                desiredPos = target.position + dir.normalized * hit.distance;
            }

            Quaternion desiredRot = Quaternion.LookRotation(
                target.position - transform.position, currentUp);

            if (!initialized)
            {
                transform.position = desiredPos;
                transform.rotation = desiredRot;
                initialized = true;
            }
            else
            {
                transform.position = Vector3.SmoothDamp(
                    transform.position, desiredPos, ref velocity, positionSmoothTime);
                transform.rotation = Quaternion.Slerp(
                    transform.rotation, desiredRot, Time.deltaTime * rotationSmoothSpeed);
            }
        }
    }
}
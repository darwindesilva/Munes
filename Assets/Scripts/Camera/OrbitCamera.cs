using UnityEngine;

public class OrbitCamera : MonoBehaviour
{
    [Header("Target")]
    public Transform target;                 // PlayerBall
    public Renderer ballRenderer;            // The ball mesh's Renderer (hidden in first person)

    [Header("Third Person")]
    public float thirdPersonDistance = 8f;
    public float thirdPersonHeight = 2f;

    [Header("First Person")]
    public float fpForwardOffset = 0.4f;     // Slight forward push so we're inside the ball

    [Header("Rotation")]
    public float mouseSensitivity = 3f;
    public float minPitch = -89f;
    public float maxPitch = 89f;

    [Header("Smoothing")]
    public float positionSmoothTime = 0.12f;
    public float rotationSmoothSpeed = 15f;
    public float upSmoothTime = 0.25f;

    [Header("Collision (third person)")]
    public float collisionRadius = 0.3f;
    public LayerMask collisionLayers;

    [Header("Mode Toggle")]
    public KeyCode toggleKey = KeyCode.T;
    public bool startInFirstPerson = false;

    private RadialGravity gravity;
    private float yaw;
    private float pitch = 10f;
    private Vector3 velocity;
    private Vector3 currentUp;
    private bool firstPerson;
    private bool initialized = false;

    void Start()
    {
        gravity = RadialGravity.Instance;
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
            initialized = false; // snap camera on next frame after toggle
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

        // Mouse input
        yaw += Input.GetAxis("Mouse X") * mouseSensitivity;
        pitch -= Input.GetAxis("Mouse Y") * mouseSensitivity;
        pitch = Mathf.Clamp(pitch, minPitch, maxPitch);

        // Smooth local up
        Vector3 targetUp = gravity.GetUp(target.position);
        if (targetUp.sqrMagnitude > 0.0001f)
        {
            if (initialized)
                currentUp = Vector3.Slerp(currentUp, targetUp, Time.deltaTime / upSmoothTime);
            else
                currentUp = targetUp;
        }

        // Build local frame
        Vector3 localFwd = Vector3.ProjectOnPlane(Vector3.forward, currentUp);
        if (localFwd.sqrMagnitude < 0.01f)
            localFwd = Vector3.ProjectOnPlane(Vector3.right, currentUp);
        localFwd.Normalize();
        Vector3 localRight = Vector3.Cross(currentUp, localFwd).normalized;

        Quaternion yawRot = Quaternion.AngleAxis(yaw, currentUp);
        Vector3 yawedFwd = yawRot * localFwd;
        Vector3 yawedRight = yawRot * localRight;
        Quaternion pitchRot = Quaternion.AngleAxis(pitch, yawedRight);
        Vector3 lookDir = pitchRot * yawedFwd;

        if (firstPerson)
        {
            // Camera sits at ball center, looking along lookDir
            Vector3 desiredPos = target.position + lookDir * fpForwardOffset;
            Quaternion desiredRot = Quaternion.LookRotation(lookDir, currentUp);

            if (!initialized)
            {
                transform.position = desiredPos;
                transform.rotation = desiredRot;
                initialized = true;
            }
            else
            {
                transform.position = Vector3.SmoothDamp(
                    transform.position, desiredPos, ref velocity, positionSmoothTime * 0.4f);
                transform.rotation = Quaternion.Slerp(
                    transform.rotation, desiredRot, Time.deltaTime * rotationSmoothSpeed * 2f);
            }
        }
        else
        {
            // Third person: behind the ball, opposite the pitch direction
            Vector3 backDir = pitchRot * (-yawedFwd);
            Vector3 desiredPos = target.position
                               + backDir * thirdPersonDistance
                               + currentUp * thirdPersonHeight;

            // Collision: pull camera in if a wall is in the way
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
using UnityEngine;

public class ChimeTrigger : MonoBehaviour
{
    private ChimeField field;
    private AudioSource source;
    private Renderer rend;
    private Color baseColor;
    private float cooldown;
    private float flash;

    public void Setup(ChimeField field, AudioSource source, Renderer rend, Color color)
    {
        this.field = field;
        this.source = source;
        this.rend = rend;
        baseColor = color;
    }

    void OnTriggerEnter(Collider other)
    {
        if (cooldown > 0f) return;
        if (other.GetComponent<BallController>() == null) return;

        Rigidbody body = other.attachedRigidbody;
        float speed = body != null ? body.linearVelocity.magnitude : 0f;

        cooldown = 1f;
        flash = 1f;
        field.PlayChime(source, speed);
    }

    void Update()
    {
        if (cooldown > 0f) cooldown -= Time.deltaTime;

        if (flash > 0f)
        {
            flash = Mathf.MoveTowards(flash, 0f, Time.deltaTime * 1.5f);
            rend.material.color = Color.Lerp(baseColor, Color.white, flash);
        }
    }
}
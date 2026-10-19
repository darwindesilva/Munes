//using UnityEngine;

//public class DebugOverlay : MonoBehaviour
//{
//    [Header("References")]
//    public BallController ball;
//    public QuadrantTracker quadrant;
//    public RadialGravity gravity;

//    private Rigidbody ballRb;
//    private GUIStyle greenStyle;
//    private GUIStyle redStyle;
//    private GUIStyle headerStyle;

//    void Start()
//    {
//        if (ball != null) ballRb = ball.GetComponent<Rigidbody>();
//    }

//    void OnGUI()
//    {
//        // Lazy-init styles (OnGUI is called twice per frame)
//        if (greenStyle == null)
//        {
//            greenStyle = new GUIStyle(GUI.skin.label) { fontSize = 14 };
//            greenStyle.normal.textColor = new Color(0.2f, 1f, 0.2f);
//            redStyle = new GUIStyle(GUI.skin.label) { fontSize = 14 };
//            redStyle.normal.textColor = new Color(1f, 0.35f, 0.35f);
//            headerStyle = new GUIStyle(GUI.skin.label) { fontSize = 16, fontStyle = FontStyle.Bold };
//            headerStyle.normal.textColor = Color.white;
//        }

//        if (ball == null) return;

//        float speed = ballRb != null ? ballRb.linearVelocity.magnitude : 0f;
//        bool grounded = ball.IsGrounded;
//        float height = 0f;
//        if (gravity != null && gravity.sphereCenter != null && ball != null)
//        {
//            Vector3 gDir = (ball.transform.position - gravity.sphereCenter.position).normalized;
//            if (Physics.Raycast(ball.transform.position, gDir, out RaycastHit hit, 1000f))
//                height = Mathf.Max(0f, hit.distance - 1f); // minus ball radius
//            else
//                height = 0f;
//        }

//        float ttl = ball.PredictTimeToLand();
//        int q = quadrant != null ? quadrant.CurrentQuadrant : -1;

//        // Build the text
//        string statusLine = grounded ? "GROUNDED" : "AIRBORNE";
//        System.Text.StringBuilder sb = new System.Text.StringBuilder();
//        sb.AppendLine("--- Chunity Inputs ---");
//        sb.AppendLine($"Speed:        {speed,7:F2} m/s");
//        sb.AppendLine($"Height:       {height,7:F2} m");
//        sb.AppendLine($"TimeToLand:   {ttl,7:F2} s");
//        sb.AppendLine($"Quadrant:     {q,7}");
//        sb.AppendLine($"Takeoff flag: {ball.JustTookOff}");
//        sb.AppendLine($"Landed flag:  {ball.JustLanded}");
//        var cam = Camera.main;
//        if (cam != null)
//        {
//            Vector3 e = cam.transform.eulerAngles;
//            float pitchSigned = e.x > 180f ? e.x - 360f : e.x;
//            sb.AppendLine($"Cam pitch:    {pitchSigned,7:F1}°");
//            sb.AppendLine($"Cam yaw:      {e.y,7:F1}°");
//        }

//        // Layout: bottom-right corner
//        float width = 260f;
//        float heightBox = 200f;
//        Rect box = new Rect(Screen.width - width - 16f, Screen.height - heightBox - 16f, width, heightBox);

//        // Semi-transparent background
//        GUI.color = new Color(0, 0, 0, 0.6f);
//        GUI.DrawTexture(box, Texture2D.whiteTexture);
//        GUI.color = Color.white;

//        // Draw status line at the top
//        GUI.Label(new Rect(box.x + 8, box.y + 6, width - 16, 20), statusLine, grounded ? greenStyle : redStyle);
//        GUI.Label(new Rect(box.x + 8, box.y + 26, width - 16, heightBox - 32), sb.ToString(), greenStyle);
//    }
//}
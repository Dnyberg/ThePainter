using UnityEngine;

public enum SplinerState
{
    /// <summary>
    /// Waiting for the target to get close enough to attach.
    /// </summary>
    Observe,

    /// <summary>
    /// Target is attached.
    /// </summary>
    Attached
}

public class SplineMovement : MonoBehaviour
{
    public Vector3 Start => entrance != null ? entrance.transform.position : Vector3.zero;
    public Vector3 End => exit != null ? exit.transform.position : Vector3.zero;

    [Tooltip("Entrance trigger, acts as the first point of the spline path.")]
    [SerializeField] private GameObject entrance;
    [Tooltip("Exit trigger, acts as the last point of the spline path.")]
    [SerializeField] private GameObject exit;
    [Tooltip("Speed at which the attached object moves in the spline.")]
    [SerializeField] private float speed = 1f;

    private Player3DController target;
    private MoverMotor motor;
    private SplinerState state;
    private float alpha = 0f;
    private bool reversed;
    private Vector3[] path;

    private void Awake()
    {
        motor = ScriptableObject.CreateInstance<LinearMoverMotor>();

        // TODO: Add more points?
        path = new[] { Start, End };

        Debug.Assert(entrance != null, $"Entrance must be set in {transform.name}, spline movement will not work.");
        Debug.Assert(exit != null, $"Exit must be set in {transform.name}, spline movement will not work.");
    }

    private void LateUpdate()
    {
        if (target == null)
            return;

        if (state == SplinerState.Observe)
        {
            var position = target.transform.position;
            alpha = (position.x - Start.x) / (End.x - Start.x);

            // If we've entered the spline, we are attaching
            if (alpha >= 0f && alpha <= 1f)
            {
                // Reverse if we're entering through the exit
                reversed = Vector3.Distance(position, Start) > Vector3.Distance(position, End);
                alpha = reversed ? 1f : 0f;

                state = SplinerState.Attached;
            }
        }
        else
        {
            alpha += target.playerControl.Movement.x * speed * Time.deltaTime;

            // Detach if we've walked outside of the spline
            var detach = alpha < 0f || alpha > 1f;

            // Even when detaching, we want to update the position
            alpha = Mathf.Clamp(alpha, 0f, 1f);

            // Evaluate the position on the spline
            var position = motor.Evaluate(path, alpha);
            position.y = target.transform.position.y;

            // Move to the new position
            if (!Mathf.Approximately(Vector3.Distance(position, target.transform.position), Mathf.Epsilon))
                target.Move(position - target.transform.position);

            // Return to observing if we've detached, we still want to attach if we're moving towards the spline again
            if (detach)
            {
                state = SplinerState.Observe;
            }
        }
    }

    public void Observe(GameObject gameObject)
    {
        // Don't override target
        if (target != null)
            return;

        target = gameObject.GetComponent<Player3DController>();

        if (target == null)
            return;

        // We reverse the order of the entrance/exit if entrance is to the right of the exit
        if (Start.x > End.x)
        {
            var temp = entrance;
            entrance = exit;
            exit = temp;
        }

        state = SplinerState.Observe;
    }

    public void Unobserve(GameObject gameObject)
    {
        if (target == null || gameObject != target.gameObject || state == SplinerState.Attached)
            return;

        target = null;
        state = SplinerState.Observe;
    }

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        if (entrance == null || exit == null)
            return;

        Gizmos.DrawLine(Start, End);
    }
#endif
}
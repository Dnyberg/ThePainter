using UnityEngine;
using UnityEngine.Serialization;

[AddComponentMenu("Painter/Triggers/Trigger Box")]
public class TriggerBox : MonoBehaviour
{
    [Header("Settings")]
    [Tooltip("Disables the trigger automatically on exit.")]
    [FormerlySerializedAs("AutoDisable")] public bool TriggerOnce;

    [Tooltip("Whether the trigger is currently disabled.")]
    [SerializeField] private bool isDisabled;
    public bool IsDisabled { get => isDisabled; private set => isDisabled = value; }
    public bool IgnoreNext { get; set; } = false;

    [Tooltip("Which layers the trigger responds to.")]
    [SerializeField] private LayerMask mask;

    [Tooltip("Whether to draw the trigger box or not.")]
    [SerializeField] private bool visualize = true;

    [Header("Events")]
    public CustomEventGameObject OnEnter;
    public CustomEventGameObject OnStay;
    public CustomEventGameObject OnExit;

    private void Enter(GameObject go)
    {
        if (IsDisabled || !MaskHasLayer(go.layer) || IgnoreNext)
            return;

        OnEnter?.Invoke(go);
        // Debug.Log($"Trigger {transform.name} entered.");
    }

    private void Stay(GameObject go)
    {
        if (IsDisabled || !MaskHasLayer(go.layer) || IgnoreNext)
            return;

        OnStay?.Invoke(go);
        // Debug.Log($"Trigger {transform.name} stay.");
    }

    private void Exit(GameObject go)
    {
        if (IgnoreNext)
        {
            IgnoreNext = false;
            return;
        }

        if (IsDisabled || !MaskHasLayer(go.layer))
            return;

        if (TriggerOnce)
            IsDisabled = true;

        OnExit?.Invoke(go);
        // Debug.Log($"Trigger {transform.name} exited.");
    }

    private void OnTriggerEnter(Collider collider) => Enter(collider.gameObject);
    private void OnTriggerStay(Collider collider) => Stay(collider.gameObject);
    private void OnTriggerExit(Collider collider) => Exit(collider.gameObject);
    private bool MaskHasLayer(int layer) => ((1 << layer) & mask) != 0;

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        if (!visualize)
            return;

        var collider = GetComponent<BoxCollider>();

        if (collider == null)
            return;

        var matrix = Gizmos.matrix;
        var color = Gizmos.color;

        var rotationMatrix = Matrix4x4.TRS(transform.position, transform.rotation, transform.lossyScale);
        Gizmos.matrix = rotationMatrix;

        Gizmos.color = new Color(0.9f, 0.4f, 0f, 0.2f);
        Gizmos.DrawCube(collider.center, collider.size);

        Gizmos.color = color;
        Gizmos.matrix = matrix;
    }
#endif
}
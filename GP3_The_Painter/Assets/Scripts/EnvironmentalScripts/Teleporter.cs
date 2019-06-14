using UnityEngine;

[ExecuteInEditMode]
public class Teleporter : MonoBehaviour
{
    public Vector3 Destination => target != null ? target.transform.position : destination;

    [Tooltip("Destination transform of the teleporter.\nOverrides Destination if set.")]
    [SerializeField] private Transform target;

    [Tooltip("Destination position of the teleporter.\nOverridden by Target if set.")]
    [SerializeField] private Vector3 destination;

    [Tooltip("If enabled, tries to ground character after teleportation.\nNote: Only works with Player3DController.")]
    [SerializeField] private bool forceGround;

    public bool isDepth;

    public void Teleport(GameObject gameObject)
    {
        var playerController = gameObject.GetComponent<Player3DController>();
        var characterController = gameObject.GetComponent<CharacterController>();

        if (playerController == null || characterController == null)
            return;

        // We check if we would collide with a teleporter at the point
        // This way we can tell it to ignore the incoming object
        var colliders = Physics.OverlapBox(Destination, characterController.bounds.extents / 2f);

        foreach (var collider in colliders)
        {
            var teleporter = collider.GetComponent<Teleporter>();
            var trigger = collider.GetComponent<TriggerBox>();

            if (teleporter != null && trigger != null)
                trigger.IgnoreNext = true;
        }

        playerController.Teleport(Destination);

        if (forceGround)
            playerController.ForceGround();
    }

}
using UnityEngine;

[AddComponentMenu("Painter/Player/PlayerControl")]
public class PlayerControl : MonoBehaviour
{



    // Start of ugly solution

    public float descendPlatformInterval = 0.35f;

    public bool canDescendPlatform = true;

    public void DescendPlatform()
    {
        if (canDescendPlatform)
        {
            Invoke("SetCanDescendPlatformToFalse", 0.1f);
            Invoke("ResetCanDescendPlatform", descendPlatformInterval);
        }
    }

    private void ResetCanDescendPlatform()
    {
        canDescendPlatform = true;
    }

    private void SetCanDescendPlatformToFalse()
    {
        canDescendPlatform = false;
    }

    //End of ugly solution

    /// <summary>
    /// Disables all control of the actor, i.e when the actor is dead.
    /// </summary>
    public bool DisableControl
    {
        get => disableControl;
        set
        {
            disableControl = value;
            Reset();
        }
    }
    [SerializeField] private bool disableControl;

    /// <summary>
    /// Whether or not to allow movement.
    /// </summary>
    public bool LockMovement
    {
        get => lockMovement;
    }
    [SerializeField] private bool lockMovement;

    /// <summary>
    /// Movement input direction.
    /// </summary>
    public Vector2 Movement
    {
        get
        {
            if (LockMovement || DisableControl)
                return Vector2.zero;
            return movement;
        }
        set => movement = value;
    }
    [SerializeField] private Vector2 movement;

    /// <summary>
    /// Whether or not the control requests jump.
    /// </summary>
    public bool Jump
    {
        get
        {
            if (DisableControl)
                return false;
            return jump;
        }
        set => jump = value;
    }
    [SerializeField] private bool jump;

    /// <summary>
    /// Whether or not the control requests interact.
    /// </summary>
    public bool Interact
    {
        get
        {
            if (DisableControl)
                return false;
            return interact;
        }
        set => interact = value;
    }
    [SerializeField] private bool interact;

    /// <summary>
    /// Reset input state to default.
    /// </summary>
    public void Reset()
    {
        movement = Vector2.zero;
        lockMovement = false;
        jump = false;
        interact = false;
    }

    /// <summary>
    /// Allows the controls to be locked by a specific key, meaning it can only be unlocked by the same key.
    /// </summary>
	private object key = null;

    /// <summary>
    /// Locks movement input.
    /// </summary>
    public void Lock() => lockMovement = true;

    /// <summary>
    /// Unlocks movement input, assuming it wasn't locked with a key.
    /// </summary>
    public void Unlock()
    {
        if (key != null)
        {
            Debug.LogWarning($"Movement was locked using a key, it must be unlocked using the same key.");
            return;
        }

        lockMovement = false;
    }

    /// <summary>
    /// Locks movement using a key, it can only be unlocked by the same key.
    /// </summary>
    public void Lock(object key)
    {
        if (this.key != null)
        {
            Debug.LogWarning($"Movement has already been locked with another key.");
            return;
        }

        this.key = key;
        lockMovement = true;
    }

    /// <summary>
    /// Unlocks movement using the same key that was used to lock the same key.
    /// </summary>
    public void Unlock(object key)
    {
        if (this.key != key)
        {
            Debug.LogWarning($"Movement wasn't locked with this key.");
            return;
        }

        this.key = null;
        lockMovement = false;
    }
}
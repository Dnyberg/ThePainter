using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

public enum InteractableType
{

    /// <summary>
    /// Will automatically activate when the interactor collides with the interactable.
    /// </summary>
    Automatic,

    /// <summary>
    /// Has to be manually activated with the interaction button.
    /// </summary>
    PickUp,

    DragPush
}

public class Interactable : MonoBehaviour
{
    /// <summary>
    /// Automatic activates on overlap, the others need the "Interaction" input
    /// </summary>
    public InteractableType Type = InteractableType.Automatic;

    /// <summary>
    /// Automatically disables the interactable on interact.
    /// </summary>
    public bool AutoDisable = true;

    /// <summary>
    /// Whether the interactable is disabled.
    /// </summary>
    public bool IsDisabled = false;

    /// <summary>
    /// Called when the interactable is interacted with.
    /// </summary>
    public UnityEventInteractor OnInteractBegin;

    /// <summary>
    /// Called when the interactable is no longer interacted with.
    /// </summary>
    public UnityEventInteractor OnInteractEnd;

    /// <summary>
    /// Whether the interactable currently has focus.
    /// </summary>
    public bool IsFocused { get; private set; } = false;

    /// <summary>
    /// Sets during begin/stop interaction.
    /// </summary>
    public bool IsInteracting { get; private set; } = false;

    /// <summary>
    /// Called when an interactor interacts with this object.
    /// </summary>
    public virtual void InteractBegin(Interactor interactor)
    {
        IsInteracting = true;

       // Debug.Log($"Begin interact {transform.name}");

        OnInteractBegin?.Invoke(interactor);
    }

    /// <summary>
    /// Called when an interactor interacts with this object.
    /// </summary>
    public virtual void InteractEnd(Interactor interactor)
    {
        if (AutoDisable)
            IsDisabled = true;

        IsInteracting = false;

       // Debug.Log($"End interact {transform.name}");

        OnInteractEnd?.Invoke(interactor);
    }

    /// <summary>
    /// Called when this is set as the focused interactable.
    /// </summary>
    public virtual void Focus(Interactor interactor)
    {
        // Already focused
        if (IsFocused)
            return;

        //Debug.Log($"Focus {transform.name}");

        IsFocused = true;
    }

    /// <summary>
    /// Called when this is no longer the focused interactable.
    /// </summary>
    public virtual void Unfocus(Interactor interactor)
    {
        // Not focused
        if (!IsFocused)
            return;

       // Debug.Log($"Unfocus {transform.name}");

        IsFocused = false;
    }
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// TODO: Create a stack of interactables?

/// <summary>
/// Allows interaction with interactables.
/// </summary>
public class Interactor : MonoBehaviour
{
    // TODO: Make this automatic?
    // Used to determine when we should ignore a teleport to avoid an endless loop
    public bool WasTeleported;

    private Interactable interactable;

    public delegate void OnInteract(InteractableType interactableType);
    public static event OnInteract OnInteractBegin;
    public static event OnInteract OnInteractEnd;

    public void Update()
    {
        // TODO: These conditions are getting a bit chunky
        if (Input.GetButton("Interact"))
        {
            if (interactable != null && !interactable.IsDisabled && interactable.Type != InteractableType.Automatic && !interactable.IsInteracting)
            {
                interactable.InteractBegin(this);
                OnInteractBegin?.Invoke(interactable.Type);               
            }
        }
        else
        {
            if (interactable != null && !interactable.IsDisabled && interactable.Type != InteractableType.Automatic && interactable.IsInteracting)
            {
                OnInteractEnd?.Invoke(interactable.Type);
                interactable.InteractEnd(this);

                if (!interactable.IsFocused)
                    SetInteractable(null);
            }
        }
    }

    private void OnEnter(GameObject gameObject)
    {
        var _interactable = gameObject.GetComponent<Interactable>();

        if (_interactable == null || _interactable.IsDisabled)
            return;

        // Ignore automatic interactables if we were just teleported
        if (WasTeleported && _interactable.Type == InteractableType.Automatic)
        {
            WasTeleported = false;
            return;
        }

        // Don't override current interactable
        //if (interactable == null)
        SetInteractable(_interactable);
    }

    private void OnExit(GameObject gameObject)
    {
        var _interactable = gameObject.GetComponent<Interactable>();

        // Only disable interactable if it's the current one
        if (_interactable != null && interactable == _interactable)
            SetInteractable(null);
    }

    private void SetInteractable(Interactable interactable)
    {
        if (this.interactable != null)
        {
            // Unfocus previous interactable
            this.interactable.Unfocus(this);

            if (this.interactable.IsInteracting)
            {
                if (this.interactable.Type == InteractableType.Automatic)
                    this.interactable.InteractEnd(this);
                else
                    return;
            }
        }

        // Set current interactable
        this.interactable = interactable;

        // No new interactable
        if (this.interactable == null)
            return;

        // Focus the new interactable
        this.interactable.Focus(this);

        // Interact if automatic
        if (this.interactable.Type == InteractableType.Automatic)
            this.interactable.InteractBegin(this);
    }

    // HACK: Allows us to unfocus an interactable manually, since moving the character controller doesn't work as expected
    public void ForceUnfocus() => SetInteractable(null);

    private void OnTriggerEnter(Collider collider) => OnEnter(collider.gameObject);
    private void OnTriggerEnter2D(Collider2D collider) => OnEnter(collider.gameObject);
    private void OnTriggerExit(Collider collider) => OnExit(collider.gameObject);
    private void OnTriggerExit2D(Collider2D collider) => OnExit(collider.gameObject);
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum PlayerState
{
    None,
    Idle,
    Walking,
    Jumping,
    Teleporting,
    DragPush,
    PickUp
}

[RequireComponent(typeof(Player3DController))]
public class SC_PlayerState : MonoBehaviour
{
    [HideInInspector]
    public static PlayerState currentState = PlayerState.Idle;

    public delegate void OnPlayerStateChanged();
    public static event OnPlayerStateChanged OnDying;
    public static event OnPlayerStateChanged OnRespawn;
    public static event OnPlayerStateChanged OnIdle;

    public delegate void OnMovementChanged();
    public static event OnMovementChanged OnStartedWalking;
    public static event OnMovementChanged OnStoppedWalking;
    public static event OnMovementChanged OnJump;
    public static event OnMovementChanged OnLanded;
    public static event OnMovementChanged OnTeleport;
    public static event OnMovementChanged OnTeleportEnd;

    public delegate void OnAbilityInteraction();
    public static event OnAbilityInteraction OnPickUp;
    public static event OnAbilityInteraction OnDragPush;
   
    public static event OnAbilityInteraction OnDropped;
    public static event OnAbilityInteraction OnHidden;
    public static event OnAbilityInteraction OnRevealed;
    public static event OnAbilityInteraction OnStopDragPush;

    private Player3DController playerController;
    private Teleporter teleporter;

    float velocity = 0f;
    float velocityLastFrame = 0f;

    bool isJumping = false;
    bool isJumpingLastFrame = false;

    bool isTeleporting = false;
    bool isTeleportingLastFrame = false;

    private void Start()
    {
        playerController = GetComponent<Player3DController>();
        teleporter = playerController.teleporterRef;

        Interactor.OnInteractBegin += SetStateInteracting;
        Interactor.OnInteractEnd += ResetState;

        PrintCurrentState();
    }

    private void Update()
    {
        velocityLastFrame = velocity;
        isJumpingLastFrame = isJumping;
        isTeleportingLastFrame = isTeleporting;
        velocity = playerController.velocity;
        isJumping = playerController.isJumping;
        isTeleporting = playerController.isTeleporting;

        if (!playerController.isJumping && velocity != 0 && Mathf.Approximately(velocityLastFrame, 0))
        {
            OnStartedWalking?.Invoke();
        }
        else if (!isJumping && Mathf.Approximately(velocity, 0) && velocityLastFrame != 0)
        {
            OnStoppedWalking?.Invoke();
        }

        if (isJumping && !isJumpingLastFrame)
        {
            OnJump?.Invoke();
        }
        else if (!isJumping && isJumpingLastFrame)
        {
            OnLanded?.Invoke();
        }

        /*if (isTeleporting && !isTeleportingLastFrame && !teleporter.isDepth)
        {
            OnTeleport?.Invoke();
        }
        else if (!isTeleporting && isTeleportingLastFrame && !teleporter.isDepth)
        {
            OnTeleportEnd?.Invoke();
        }*/
    }

    public void SetStateInteracting(InteractableType interactableType)
    {
        switch (interactableType)
        {
            case InteractableType.PickUp:
                {
                    currentState = PlayerState.PickUp;
                    Invoke("ResetState", 1f);
                    OnPickUp?.Invoke();
                    PrintCurrentState();
                    break;
                }
            case InteractableType.DragPush:
                {
                    currentState = PlayerState.DragPush;
                    OnDragPush?.Invoke();
                    PrintCurrentState();

                    break;
                }
        }
    }

    public void ResetState(InteractableType previousInteractableType)
    {
        currentState = PlayerState.Idle;
        OnIdle?.Invoke();
        PrintCurrentState();
    }

    void PrintCurrentState()
    {
       // Debug.Log("Current Player State: " + currentState);
    }
}
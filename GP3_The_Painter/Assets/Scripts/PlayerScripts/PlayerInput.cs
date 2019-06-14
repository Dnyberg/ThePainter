using UnityEngine;

[AddComponentMenu("Painter/Player/PlayerInput")]
public class PlayerInput : MonoBehaviour
{
    private PlayerControl control;

    private void Awake()
    {
        control = GetComponent<PlayerControl>();
    }

    private void Update()
    {
        control.Movement = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
        control.Jump = Input.GetButtonDown("Jump");
        control.Interact = Input.GetButton("Interact");
    }
}
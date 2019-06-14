using Cinemachine;
using UnityEngine;

public class SC_TeleportFollow : MonoBehaviour
{
    public float teleportDepthOffset = -3f;
    public float interpSpeed = 5f;
    public float horizontalDamping = 3f;

    private Player3DController controller;
    private CinemachineTransposer transposer;
    private float startDepthOffset;
    private float startHorizontalDamping;
    private bool teleporting;

    private void Awake()
    {
        var player = GameManager.Instance.Player;
        Debug.Assert(player != null, $"GameManager returned a null Player.");

        controller = GameManager.Instance.Player.GetComponent<Player3DController>();
        Debug.Assert(controller != null, $"No controller attached to the Player.");

        transposer = GetComponent<CinemachineVirtualCamera>()?.GetCinemachineComponent<CinemachineTransposer>();
        Debug.Assert(transposer != null, $"Unable to find CinemachineVirtualCamera component.");

        controller.OnTeleportBegin.AddListener(PlayerTeleportBegin);
        controller.OnTeleportEnd.AddListener(PlayerTeleportEnd);

        startDepthOffset = transposer.m_FollowOffset.z;
        startHorizontalDamping = transposer.m_XDamping;
    }

    private void Update()
    {
        var targetOffset = teleporting ? teleportDepthOffset : startDepthOffset;
        var targetDamping = teleporting ? horizontalDamping : startHorizontalDamping;

        transposer.m_XDamping = targetDamping;
        transposer.m_FollowOffset.z = Mathf.Lerp(transposer.m_FollowOffset.z, targetOffset, interpSpeed * Time.deltaTime);
    }

    private void PlayerTeleportBegin() => teleporting = true;
    private void PlayerTeleportEnd() => teleporting = false;
}
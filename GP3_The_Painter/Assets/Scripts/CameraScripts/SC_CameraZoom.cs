using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_CameraZoom : MonoBehaviour
{
    public float zoomSpeed = 1f;

    bool isZoomedIn = true;
    bool isZooming = false;
    Vector3 zoomedInPosition;
    static bool canPlayerZoom = true;

    SC_FollowPlayerCamera followPlayerCamera;
    [HideInInspector] public PlayerControl playerControl;
    Player3DController myPlayer;

    static SC_CameraZoom thisCameraZoom;

    private void Start()
    {
        followPlayerCamera = GetComponent<SC_FollowPlayerCamera>();
        playerControl = followPlayerCamera.player.GetComponent<PlayerControl>();
        myPlayer = GameObject.Find("3DPlayer")?.GetComponent<Player3DController>();
        thisCameraZoom = this;
    }
    /// <summary>
    /// Use with caution
    /// </summary>
    public void ZoomOut(float ZoomSpeed)
    {
        StartCoroutine(ZoomOutLerp(ZoomSpeed));
    }

    /// <summary>
    /// Use with caution
    /// </summary>
    public void ZoomIn(float ZoomSpeed)
    {
        StartCoroutine(ZoomInLerp(ZoomSpeed));
    }

    /// <summary>
    /// Temporarily disables the players ability to zoom with the camera
    /// </summary>
    public static void DisablePlayerInput()
    {
        canPlayerZoom = false;
    }

    /// <summary>
    /// Enables the players ability to zoom with the camera
    /// </summary>
    public static void EnablePlayerInput()
    {
        canPlayerZoom = true;
    }

    void Update()
    {
        if (!canPlayerZoom) return;

        float ZoomAxis = Mathf.Round(Input.GetAxis("Zoom"));

        if (!Mathf.Approximately(ZoomAxis, 0f))
        {
            if (isZooming) return;

            if (ZoomAxis < 0 && isZoomedIn)
            {
                StartCoroutine(ZoomOutLerp(zoomSpeed));
            }
            else if (!isZoomedIn && ZoomAxis > 0)
            {
                StartCoroutine(ZoomInLerp(zoomSpeed));
            }
        }
    }

    IEnumerator ZoomOutLerp(float ZoomSpeed)
    {
        followPlayerCamera.shouldUpdatePosition = false;
        isZooming = true;
        isZoomedIn = false;
        myPlayer.playerControl.DisableControl = true;

        float alpha = 0f;
        zoomedInPosition = transform.position;
        Vector3 targetPosition = followPlayerCamera.frame.zoomOutCameraTransform.position;
        Vector3 newPosition;

        while (transform.position != targetPosition)
        {
            alpha += Time.deltaTime * ZoomSpeed;
            newPosition = Vector3.Lerp(zoomedInPosition, targetPosition, alpha);
            transform.position = newPosition;

            yield return new WaitForEndOfFrame();
        }

        isZooming = false;
        yield return null;
    }

    IEnumerator ZoomInLerp(float ZoomSpeed)
    {
        isZooming = true;
        isZoomedIn = true;

        float alpha = 0f;
        Vector3 startPosition = transform.position;
        Vector3 targetPosition = zoomedInPosition;
        Vector3 newPosition;
       
        while (transform.position != targetPosition)
        {
            alpha += Time.deltaTime * ZoomSpeed;
            newPosition = Vector3.Lerp(startPosition, targetPosition, alpha);
            transform.position = newPosition;

            yield return new WaitForEndOfFrame();

        }

        followPlayerCamera.shouldUpdatePosition = true;
        isZooming = false;
        Invoke("ActivatePlayerMovement", 1.5f);

        yield return null;
    }

    public void ActivatePlayerMovement()
    {
        myPlayer.playerControl.DisableControl = false;
    }
}

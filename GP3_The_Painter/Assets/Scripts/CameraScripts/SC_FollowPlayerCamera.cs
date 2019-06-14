using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_FollowPlayerCamera : MonoBehaviour
{
    public Camera paintingCamera;
    public GameObject player;
    public SC_Frame frame;
    [Header("DEBUG ONLY VARIABLES")]
    public bool shouldUpdatePosition = true;

    [HideInInspector]
    public float cameraViewingDistance = 3.5f;


    Camera thisCamera;

    float playerCameraXAngle = 0f;
    float playerCameraYAngle = 0f;
    float playerXAnglePercent = 0f;
    float playerYAnglePercent = 0f;

    Vector3 cameraToPlayerDirection = Vector3.zero;
    Vector3 newCameraPos = Vector3.zero;

    private void Start()
    {
        thisCamera = GetComponent<Camera>();


        player = GameManager.Instance.Player;

        cameraViewingDistance = frame.cameraViewingDistance;
    }

    private void Update()
    {

        if (!shouldUpdatePosition) return;

        cameraToPlayerDirection = player.transform.position - paintingCamera.transform.position;

        //calculate angle
        playerCameraXAngle = Mathf.Atan2(cameraToPlayerDirection.x, cameraToPlayerDirection.z) * Mathf.Rad2Deg;
        playerCameraYAngle = Mathf.Atan2(cameraToPlayerDirection.y, cameraToPlayerDirection.z) * Mathf.Rad2Deg;
        //Debug.Log("Camera Y Angle:" + playerCameraYAngle + "Camera X Angle: " + playerCameraXAngle);

        //playerCameraYAngle -= frame.shaderOffset.y;


        //Quaternion ForwardDirection = Quaternion.AngleAxis(playerCameraYAngle, new Vector3(1f, 0f, 0f));

        //Debug.DrawRay(paintingCamera.transform.position, ForwardDirection * paintingCamera.transform.forward * 100f, Color.red);


        //calculate percent of FOV
        playerXAnglePercent = playerCameraXAngle + (paintingCamera.fieldOfView / 2);
        playerXAnglePercent /= paintingCamera.fieldOfView;

        playerYAnglePercent = playerCameraYAngle + (paintingCamera.fieldOfView / 2);
        playerYAnglePercent /= paintingCamera.fieldOfView;



        //move the camera
        float xAdd = frame.frameWidth * playerXAnglePercent;
        float yAdd = frame.frameHeight * playerYAnglePercent;
        //yAdd *= frameWidth / frameHeight;

        newCameraPos = new Vector3(frame.bottomLeftPoint.transform.position.x,
                                    frame.bottomLeftPoint.transform.position.y,
                                    frame.bottomLeftPoint.transform.position.z - frame.cameraViewingDistance);

        newCameraPos.x += xAdd;
        newCameraPos.y += yAdd - frame.cameraHeightOffset;


        //transform.position = Vector3.MoveTowards(transform.position, newCameraPos, Time.deltaTime);
        //Debug.Log("Player Percent: " + playerXAnglePercent);

        var target = Vector3.Lerp(transform.position, newCameraPos, 8f * Time.deltaTime);

        transform.position = target;

    }


}

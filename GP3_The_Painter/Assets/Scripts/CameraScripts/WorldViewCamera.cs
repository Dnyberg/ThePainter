using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldViewCamera : MonoBehaviour
{
    private Vector3 offset;
    public GameObject endPos;
    public GameObject myPlayer;
    public bool isLocked;

    bool isLookingAtWorldmap = false;

    private void Update()
    {
        if (isLocked)
            return;

        CameraZoomWorld();
    }

    private void CameraZoomWorld()
    {
        if (Input.GetKey("m"))
        {
            isLookingAtWorldmap = true;
            transform.position = Vector3.Lerp(transform.position, endPos.transform.position, Time.deltaTime * 2f);
        }
        else
        {
            isLookingAtWorldmap = false;
            transform.position = Vector3.Lerp(transform.position, myPlayer.transform.position + offset, Time.deltaTime * 2f);
        }
    }
}

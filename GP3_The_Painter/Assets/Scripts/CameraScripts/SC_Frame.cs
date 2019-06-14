using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_Frame : MonoBehaviour
{
    public Collider Collider;

    public GameObject bottomLeftPoint;
    public GameObject topRightPoint;

    public float cameraHeightOffset;

    public float cameraViewingDistance = 3.5f;

    public Transform zoomOutCameraTransform;


    [HideInInspector]
    public float frameWidth;
    [HideInInspector]
    public float frameHeight;


    private void Awake()
    {
        //Calculate width & height
        Vector3 framePointDirection = topRightPoint.transform.position - bottomLeftPoint.transform.position;

        frameWidth = new Vector3(framePointDirection.x, 0, 0).magnitude;
        frameHeight = new Vector3(0, framePointDirection.y, 0).magnitude;

        Collider = GetComponent<Collider>();

        //Debug.LogFormat("Frame mesh width & height: {0} .. {1} ", frameWidth, frameHeight);
    }
}

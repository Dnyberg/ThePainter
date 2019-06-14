using UnityEngine;

public class SC_CameraArea : MonoBehaviour
{
    public Camera paintingCamera;
    public SC_Frame frame;
    public GameObject player;


    SC_FollowPlayerCamera followPlayerCamera;

    private void Start()
    {
        followPlayerCamera = GameObject.Find("CalculateFollowPlayerCameraPoint")?.GetComponent<SC_FollowPlayerCamera>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject == player)
        {
            followPlayerCamera.frame = frame;
            followPlayerCamera.paintingCamera = paintingCamera;
            followPlayerCamera.cameraViewingDistance = frame.cameraViewingDistance;

            GameManager.Instance.UpdatePlayerArea(paintingCamera, frame);
        }
    }
}

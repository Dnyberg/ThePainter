using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

public class SC_ActivateShadowSmudgeTrigger : MonoBehaviour
{
    [Tooltip("This should be a reference to the RemoveSmudgeTriggerObject that you want to activate when the player overlaps this object")]
    public GameObject removeSmudgeTriggerObject;

    SC_CameraZoom cameraZoom;
    SC_RemoveSmudgeTrigger removeSmudgeTrigger = null;

    void Start()
    {

        cameraZoom = GameObject.Find("CalculateFollowPlayerCameraPoint").GetComponent<SC_CameraZoom>();

        removeSmudgeTrigger = removeSmudgeTriggerObject.GetComponent<SC_RemoveSmudgeTrigger>();
        Assert.IsNotNull(removeSmudgeTrigger, "The Game Object \"RemoveSmudgeTriggerObject\" does not contain a \"RemoveSmudgeTriggerScript\". Is the reference set correctly?");
        removeSmudgeTrigger.smudge.gameObject.SetActive(false);
        removeSmudgeTriggerObject.SetActive(false);
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.name == "3DPlayer")
        {
            ActivateSmudge();
        }
    }


    void ActivateSmudge()
    {
        Collider thisCollider = GetComponent<Collider>();
        Destroy(thisCollider);

        SC_CameraZoom.DisablePlayerInput();

       






        Invoke("ZoomOutCamera", 2f);
       

        


        //Also needs to stop player input for a bit
    }

    void ActivateSmudgeObjects()
    {
        removeSmudgeTriggerObject.SetActive(true);
        removeSmudgeTrigger.smudge.gameObject.SetActive(true);
    }


    void ZoomOutCamera()
    {
        cameraZoom.ZoomOut(0.5f);

        GameObject.Find("GameManager").GetComponent<GameManager>()?.Shadow.GetComponent<ShadowController>()?.Smudge();

        Invoke("ActivateSmudgeObjects", 5f);
        Invoke("ZoomInCamera", 7f);
    }


    void ZoomInCamera()
    {
        cameraZoom.ZoomIn(0.5f);
        SC_CameraZoom.EnablePlayerInput();
    }
}

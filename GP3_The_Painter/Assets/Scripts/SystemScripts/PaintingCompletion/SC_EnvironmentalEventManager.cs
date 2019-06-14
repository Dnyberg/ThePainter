using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class SC_EnvironmentalEventManager : MonoBehaviour
{
    public List<SC_EnvironmentalEvent> environmentalEvents;

    [Tooltip("The post process events will be booted first")]
    public UnityEvent OnAllEventsTriggered_PostProcessEvents;
    [Tooltip("The environment events will be booted second")]
    public UnityEvent OnAllEventsTriggered_EnvironmentEvents;
    [Tooltip("The remove blocker events will be booted third")]
    public UnityEvent OnAllEventsTriggered_BlockerEvent;

    private SC_CameraZoom zoomCamera;

    int currentEventsTriggered = 0;

    private void Start()
    {
        zoomCamera = GameObject.Find("CalculateFollowPlayerCameraPoint").GetComponent<SC_CameraZoom>();

        for (int i = 0; i < environmentalEvents.Count; i++)
        {
            environmentalEvents[i].eventManager = this;
        }
    }

    public void EventTriggered()
    {
        StartCoroutine(OnEventTriggered());
    }

    IEnumerator OnEventTriggered()
    {
        currentEventsTriggered++;

        if (currentEventsTriggered >= environmentalEvents.Count)
        {
            yield return new WaitForSeconds(1.5f);
            zoomCamera.ZoomOut(1f);
            SC_CameraZoom.DisablePlayerInput();
            zoomCamera.playerControl.DisableControl = true;
            yield return new WaitForSeconds(1.5f);
            OnAllEventsTriggered_EnvironmentEvents?.Invoke();
            yield return new WaitForSeconds(1.5f);
            OnAllEventsTriggered_PostProcessEvents?.Invoke();
            yield return new WaitForSeconds(1.5f);
            OnAllEventsTriggered_BlockerEvent?.Invoke();
            yield return new WaitForSeconds(1.5f);
            zoomCamera.ZoomIn(1f);
            yield return new WaitForSeconds(2f);
            zoomCamera.ActivatePlayerMovement();
            SC_CameraZoom.EnablePlayerInput();
        }

        yield return null;
    }
}

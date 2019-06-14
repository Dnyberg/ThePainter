using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class SC_EnvironmentalEvent : MonoBehaviour
{
    [HideInInspector]
    public SC_EnvironmentalEventManager eventManager;

    public UnityEvent OnEventTriggered;


    public void TriggerEvent()
    {
        OnEventTriggered?.Invoke();
        eventManager?.EventTriggered();
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// This script will deactivate the object on start and then activate it when the event is triggered
/// </summary>
public class SC_EnableObjectEvent : MonoBehaviour
{
    public GameObject objectToEnable;

    void Start()
    {
        objectToEnable.SetActive(false);
    }

   
    public void OnEventTriggered()
    {
        objectToEnable.SetActive(true);
    }
}

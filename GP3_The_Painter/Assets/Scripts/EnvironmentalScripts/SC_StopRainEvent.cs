using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_StopRainEvent : MonoBehaviour
{
    

    public void OnEventTriggered()
    {
        gameObject.SetActive(false);
    }

}

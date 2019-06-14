using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_RemoveObjectEvent : MonoBehaviour
{
    public void OnEventTriggered()
    {
        gameObject.SetActive(false);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_DisableSoundEvent : MonoBehaviour
{
    public void OnEventTriggered()
    {
        GetComponent<AudioSource>()?.Stop();
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_EnableSoundEvent : MonoBehaviour
{
    public void OnEventTriggered()
    {
        GetComponent<AudioSource>()?.Play();
    }
}

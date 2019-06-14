using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_DaughterCougingSoundEvent : MonoBehaviour
{
    AudioSource coughingCue;

    private void Start()
    {
        coughingCue = GetComponent<AudioSource>();
    }

    public void OnEventTriggered()
    {
        PlaySound();
    }

    void PlaySound()
    {
        coughingCue.Play();
        Invoke("PlaySound", 15f);
    }


}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_OnOverlapEnableSoundEvent : MonoBehaviour
{
    public AudioSource soundToPlay;


    private void OnTriggerEnter(Collider other)
    {
        if (other.name == "3DPlayer")
        {

           soundToPlay.Play();
        }
    }
}

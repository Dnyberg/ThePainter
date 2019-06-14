using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class SC_LoversSoundEvent : MonoBehaviour
{
    public AudioSource voiceCue;
    public AudioSource laughCue;



   public void OnEventTriggered()
    {
        voiceCue.PlayDelayed(0.5f);
        laughCue.PlayDelayed(4f);
    }




   

}

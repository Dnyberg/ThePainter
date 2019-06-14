using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_FatherDaughterPlayingEvent : MonoBehaviour
{
    public AudioSource playingCue;
    public AudioSource playingCoughCue;

   public void OnEventTriggered()
    {
        PlaySounds();
    }




    void PlaySounds()
    {
        playingCoughCue.Play();
        playingCue.PlayDelayed(7.5f);

        Invoke("PlaySounds", 15f);
    }
}

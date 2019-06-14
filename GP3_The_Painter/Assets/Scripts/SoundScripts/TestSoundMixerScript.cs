using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class TestSoundMixerScript : MonoBehaviour
{

    public AudioMixer TestGroup2;
    float value = 1f;
   
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.L))
        {
            value = value == 0 ? 1f : 0f;

            TestGroup2.SetFloat("TestGroup2Volume", -100f);
        }
        
    }
}

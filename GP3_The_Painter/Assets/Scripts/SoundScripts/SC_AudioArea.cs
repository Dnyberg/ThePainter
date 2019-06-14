using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class SC_AudioArea : MonoBehaviour
{
    public AudioMixer audioMixer;
    public AudioArea areaName;

    string audioAreaMaster = "";
    float areaMasterVolume = 0f;
    bool isSettingAudioActive = false;
    bool isSettingAudioNotActive = false;


    private void Start()
    {
        audioAreaMaster = areaName.ToString() + "Master";
        areaMasterVolume = SC_SoundManager.audioAreaMasterVolumes[(int)areaName];
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            if (isSettingAudioActive) return;

           // Debug.Log("Entered audio area: " + areaName.ToString());

            // audioMixer.SetFloat(audioAreaMaster, areaMasterVolume);


            StartCoroutine(SetAudioActive());
        }
    }


    private void OnTriggerExit(Collider other)
    {
       // Debug.Log("Something Happened");



        if (other.gameObject.name == "3DPlayer" || other.gameObject.name == "Mouth")
        {
            if (isSettingAudioNotActive) return;
           //Debug.Log(other.name + "Exited audio area: " + areaName.ToString());
            //audioMixer.SetFloat(audioAreaMaster, -80f);


            StartCoroutine(SetAudioNotActive());
        }
    }




    IEnumerator SetAudioActive()
    {
        isSettingAudioActive = true;
        float targetVolume = areaMasterVolume;
        float startVolume = 0f;
        audioMixer.GetFloat(audioAreaMaster, out startVolume);
        float newVolume = 0f;
        float alpha = 0f;

        //Debug.Log("Target Volume: " + targetVolume);

        while (newVolume != targetVolume)
        {
            alpha += Time.deltaTime;

            newVolume = Mathf.Lerp(startVolume, targetVolume, alpha);

            audioMixer.SetFloat(audioAreaMaster, newVolume);

           /* float myFloat;
            audioMixer.GetFloat(audioAreaMaster, out myFloat);
            Debug.Log("Set active volume: " + myFloat);*/

            yield return new WaitForEndOfFrame();
        }

        //Debug.Log("Finished setting audio active");

        isSettingAudioActive = false;

        yield return null;
    }

    IEnumerator SetAudioNotActive()
    {
        isSettingAudioNotActive = true;
        float targetVolume = -79;
        float startVolume = 0f;
        audioMixer.GetFloat(audioAreaMaster, out startVolume);
        float newVolume = 0f;
        float alpha = 0f;
        //Debug.Log("Target Volume: " + targetVolume);

        while (newVolume != targetVolume)
        {
            alpha += Time.deltaTime;

            newVolume = Mathf.Lerp(startVolume, targetVolume, alpha);

            audioMixer.SetFloat(audioAreaMaster, newVolume);
            float myFloat;
            audioMixer.GetFloat(audioAreaMaster, out myFloat);
            //Debug.Log("Set not active volume: " + myFloat);


            yield return new WaitForEndOfFrame();
        }

        // Debug.Log("Finished setting audio not active");

        isSettingAudioNotActive = false;

        yield return null;
    }
}

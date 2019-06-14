using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_FadeOutSound : MonoBehaviour
{
    AudioSource soundCue;


    private void Start()
    {
        soundCue = GetComponent<AudioSource>();
    }

    public void FadeOutSoundEvent()
    {
        StartCoroutine(FadeOutLerp());
    }


    IEnumerator FadeOutLerp()
    {
        float alpha = 0f;
        float startVolume = soundCue.volume;
        float newVolume;

        while (soundCue.volume != 0f)
        {
            alpha += Time.deltaTime / 2f;

            newVolume = Mathf.Lerp(startVolume, 0f, alpha);

            soundCue.volume = newVolume;

            yield return new WaitForEndOfFrame();
        }



        yield return null;


    }
}

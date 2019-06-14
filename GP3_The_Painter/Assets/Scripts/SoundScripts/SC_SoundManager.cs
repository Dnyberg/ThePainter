using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.Assertions;


public enum AudioArea
{
    LoversBridge,
    AppleOfMyEye,
    Level3,
    Level4
}


public class SC_SoundManager : MonoBehaviour
{
    public AudioMixer audioMixer;

    public static string[] audioAreaNames = { AudioArea.LoversBridge.ToString(), AudioArea.AppleOfMyEye.ToString(), AudioArea.Level3.ToString(), AudioArea.Level4.ToString() };

    public static float[] audioAreaMasterVolumes = new float[4];
    public static float[] audioAreaAmbianceVolumes = new float[4];
    public static float[] audioAreaEnvironmentVolumes = new float[4];

   
    private void Awake()
    {
        for (int i = 0; i < audioAreaNames.Length; i++)
        {
            
                audioMixer.GetFloat(audioAreaNames[i] + "Master", out audioAreaMasterVolumes[i]);
                audioMixer.GetFloat(audioAreaNames[i] + "Ambiance", out audioAreaAmbianceVolumes[i]);
                audioMixer.GetFloat(audioAreaNames[i] + "Environment", out audioAreaEnvironmentVolumes[i]);

            Assert.AreNotEqual(0f, audioAreaMasterVolumes[i], "Master channel volume of: " + audioAreaNames[i] + " can't be exactly 0");
/*

                 Debug.LogFormat("{0} Sound Volumes - Master: {1} .. Ambiance: {2} .. Environment: {3}", 
                  audioAreaNames[i], audioAreaMasterVolumes[i], audioAreaAmbianceVolumes[i], audioAreaEnvironmentVolumes[i]);*/
            
        }



    }
}

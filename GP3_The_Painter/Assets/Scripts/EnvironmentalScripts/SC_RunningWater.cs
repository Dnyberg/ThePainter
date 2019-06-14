using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_RunningWater : MonoBehaviour
{
    Renderer renderer;

    // Start is called before the first frame update
    void Start()
    {
        renderer = GetComponent<Renderer>();
        renderer.material.SetVector("_WaveMovment1", Vector4.zero);
        renderer.material.SetVector("_WaveMovment2", Vector4.zero);
    }

    public void OnWaterActivated()
    {
        //Activate the shader
        renderer.material.SetVector("_WaveMovment1", new Vector4(-0.03f, 0f, 0f, 0f));
        renderer.material.SetVector("_WaveMovment2", new Vector4(0.05f, 0.05f, 0f, 0f));

        //Activate the sound
        GetComponent<AudioSource>()?.Play();
    }
}

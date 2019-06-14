using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class PostProcessTest : MonoBehaviour
{
    public float bloomMax = 5f;
    Bloom bloomLayer = null;

    private void Start()
    {
        PostProcessVolume volume = GetComponent<PostProcessVolume>();
        volume.profile.TryGetSettings(out bloomLayer);
        bloomLayer.enabled.value = true;
    }

    private void Update()
    {
        if (bloomLayer.intensity.value <= bloomMax)
        {
            bloomLayer.intensity.value += 0.1f;
        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class PPValueChanger : MonoBehaviour
{
    public float bloom = 5f;
    public float temperature = 5f;
    public float saturation = 5f;
    public float ev = 5f;

    public bool temperatureNegative = false;
    public bool saturationNegative = false;
    public bool evNegative = false;
    private bool keyPressed = false;

    Bloom bloomLayer = null;
    ColorGrading colorGradingLayer = null;
    AutoExposure autoExposureLayer = null;

    private void Start()
    {
        PostProcessVolume volume = GetComponent<PostProcessVolume>();
        volume.profile.TryGetSettings(out bloomLayer);
        volume.profile.TryGetSettings(out colorGradingLayer);
        volume.profile.TryGetSettings(out autoExposureLayer);
        colorGradingLayer.enabled.value = true;
        bloomLayer.enabled.value = true;
        autoExposureLayer.enabled.value = true;
    }

    private void Update()
    {
        if (Input.GetKeyDown("f") || keyPressed)
        {
            keyPressed = true;

            Bloom();
            ColorGrading();
            AutoExposure();
        }
    }

    private void Bloom()
    {
        if (bloomLayer.intensity.value <= bloom)
        {
            bloomLayer.intensity.value += 0.1f;
        }
    }

    private void ColorGrading()
    {
        if (colorGradingLayer.temperature.value <= temperature && !temperatureNegative)
        {
            colorGradingLayer.temperature.value += 1f;
        }
        else if (colorGradingLayer.temperature.value >= temperature && temperatureNegative)
        {
            colorGradingLayer.temperature.value -= 1f;
        }

        if (colorGradingLayer.saturation.value <= saturation && !saturationNegative)
        {
            colorGradingLayer.saturation.value += 1f;
        }
        else if (colorGradingLayer.saturation.value >= saturation && saturationNegative)
        {
            colorGradingLayer.saturation.value -= 1f;
        }
    }

    private void AutoExposure()
    {
        if (autoExposureLayer.maxLuminance.value <= ev && autoExposureLayer.minLuminance.value <= ev && !evNegative)
        {
            autoExposureLayer.maxLuminance.value += 1f;
            autoExposureLayer.minLuminance.value += 1f;
        }
        else if (autoExposureLayer.maxLuminance.value >= ev && autoExposureLayer.minLuminance.value >= ev && evNegative)
        {
            autoExposureLayer.maxLuminance.value -= 1f;
            autoExposureLayer.minLuminance.value -= 1f;
        }
    }
}

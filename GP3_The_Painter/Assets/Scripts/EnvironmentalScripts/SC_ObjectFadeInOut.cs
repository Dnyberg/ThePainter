using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_ObjectFadeInOut : MonoBehaviour
{
    [Tooltip("The material must be in fade mode")]
    public string fadeoutObjectTag;
    [Tooltip("The material must be in fade mode")]
    public string fadeinObjectTag;
    public float lerpSpeed = 0;

    private Material fadeoutObjectMaterial;
    private Material fadeinObjectMaterial;

    private void Start()
    {
        fadeoutObjectMaterial = GameObject.FindGameObjectWithTag(fadeoutObjectTag).GetComponentInChildren<MeshRenderer>().material;
        fadeinObjectMaterial = GameObject.FindGameObjectWithTag(fadeinObjectTag).GetComponentInChildren<MeshRenderer>().material;
    }

    public void OnEventTriggered()
    {
        StartCoroutine(LerpMaterial());
        StartCoroutine(FadeIn());
    }

    IEnumerator LerpMaterial()
    {
        float alpha = 0f;
        float newFadeoutMaterialOpacity = 0f;
        float fadeoutStartMaterialOpecity = fadeoutObjectMaterial.color.a;

        while (fadeoutObjectMaterial.color.a != 0)
        {
            alpha += Time.deltaTime;

            newFadeoutMaterialOpacity = Mathf.Lerp(fadeoutStartMaterialOpecity, 0f, lerpSpeed * alpha);
            Color newColor = new Color(fadeoutObjectMaterial.color.r, fadeoutObjectMaterial.color.g, fadeoutObjectMaterial.color.b, newFadeoutMaterialOpacity);
            fadeoutObjectMaterial.color = newColor;

            yield return new WaitForEndOfFrame();
        }

        yield return null;
    }

    IEnumerator FadeIn()
    {
        float alpha = 0f;
        float newFadeinMaterialOpacity = 0f;
        float fadeinStartMaterialOpecity = fadeinObjectMaterial.color.a;

        while (fadeinObjectMaterial.color.a != 1)
        {
            alpha += Time.deltaTime;

            newFadeinMaterialOpacity = Mathf.Lerp(fadeinStartMaterialOpecity, 1f, lerpSpeed * alpha);
            Color newColor = new Color(fadeinObjectMaterial.color.r, fadeinObjectMaterial.color.g, fadeinObjectMaterial.color.b, newFadeinMaterialOpacity);
            fadeinObjectMaterial.color = newColor;

            yield return new WaitForEndOfFrame();
        }

        yield return null;
    }
}
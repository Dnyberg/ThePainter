using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_GodRayEvent : MonoBehaviour
{
    [HideInInspector] public Renderer[] godRay = null;

    private void Start()
    {
        godRay = GameObject.Find("GodRay")?.GetComponentsInChildren<Renderer>();
    }

    public void OnEventTriggered()
    {
        StartCoroutine(ScaleIncrease());
    }

    IEnumerator ScaleIncrease()
    {

        float alpha = 0f;
        float newScale = 0f;
        float startScale1 = godRay[0].material.GetFloat("_Scale");

        while (godRay[0].material.GetFloat("_Scale") <= 6)
        {
            alpha += Time.deltaTime;

            newScale = Mathf.Lerp(startScale1, 6f, alpha);
            godRay[0].material.SetFloat("_Scale", newScale);
            godRay[1].material.SetFloat("_Scale", newScale);
            godRay[2].material.SetFloat("_Scale", newScale);

            yield return new WaitForEndOfFrame();
        }

        yield return null;
    }
}

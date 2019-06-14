using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_HouseLightsTurnON : MonoBehaviour
{
    public float lightIntensity;
    public Light[] houseLights;

    public void CallLerpLight()
    {
        StartCoroutine(LerpLight());
    }

    IEnumerator LerpLight()
    {
        float duration = 0f;
        float newIntensity = 0f;

        while (houseLights[houseLights.Length - 1].intensity <= lightIntensity)
        {
            duration += Time.deltaTime;
            for (int i = 0; i < houseLights.Length; i++)
            {
                newIntensity = Mathf.Lerp(houseLights[i].intensity, lightIntensity, duration);
                houseLights[i].intensity = newIntensity;
            }
            yield return new WaitForEndOfFrame();
        }
        yield return null;
    }
}

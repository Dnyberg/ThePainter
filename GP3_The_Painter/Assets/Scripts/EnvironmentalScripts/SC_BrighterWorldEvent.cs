using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_BrighterWorldEvent : MonoBehaviour
{
    public float lerpDuration = 0;
    public float yAxisEndPos = 0;
    [Tooltip("This is the parent object of the two post process volumes that should be moved")]
    public GameObject PostProcessObject;

    public void OnTriggerEvent()
    {
        StartCoroutine(LerpPP());
    }

    IEnumerator LerpPP()
    {
        float duration = 0f;
        Vector3 ppPos = PostProcessObject.transform.localPosition;

        while (ppPos.y >= yAxisEndPos)
        {
            duration += Time.deltaTime;
            ppPos.y = Mathf.Lerp(ppPos.y, yAxisEndPos, lerpDuration * duration);
            PostProcessObject.transform.localPosition = ppPos;

            yield return new WaitForEndOfFrame();
        }

        yield return null;
    }
}

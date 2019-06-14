using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_MakeSkyBrigtherEvent : MonoBehaviour
{
    SpriteRenderer skySprite;
    public float lerpSpeed = 0;

    private void Start()
    {
        skySprite = GetComponent<SpriteRenderer>();
    }

    public void OnEventTriggered()
    {
        StartCoroutine(LerpSkyColor());
    }

    IEnumerator LerpSkyColor()
    {
        Color startColor = skySprite.color;
        Color targetColor = Color.white;
        float alpha = 0f;

        while (skySprite.color != targetColor)
        {
            alpha += Time.deltaTime;
            Color newColor = Color.Lerp(startColor, targetColor, lerpSpeed * alpha);
            skySprite.color = newColor;

            yield return new WaitForEndOfFrame();
        }

        yield return null;
    }
}

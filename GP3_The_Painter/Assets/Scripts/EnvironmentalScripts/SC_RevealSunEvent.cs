using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_RevealSunEvent : MonoBehaviour
{
    SpriteRenderer sunSprite;
    public float lerpSpeed = 0;

    private void Start()
    {
        sunSprite = GetComponent<SpriteRenderer>();
    }

    public void OnEventTriggered()
    {
        StartCoroutine(LerpSunColorAndPosition());
    }

    IEnumerator LerpSunColorAndPosition()
    {
        Color startColor = sunSprite.color;
        Color targetColor = Color.white;
        float alpha = 0f;

        while (sunSprite.color != targetColor)
        {
            alpha += Time.deltaTime;
            Color newColor = Color.Lerp(startColor, targetColor, lerpSpeed * alpha);
            sunSprite.color = newColor;

            yield return new WaitForEndOfFrame();
        }

        yield return null;
    }
}

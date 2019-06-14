using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_FadeInSpriteEvent : MonoBehaviour
{
    [Tooltip("Sprite alpha needs to be 0")]
    public SpriteRenderer sprite;
    public float lerpSpeed = 0;

    private void Start()
    {
        sprite = GetComponent<SpriteRenderer>();
    }

    public void OnEventTriggered()
    {
        StartCoroutine(LerpSprite());
    }

    IEnumerator LerpSprite()
    {
        float alpha = 0f;
        float newSpriteOpacity = 0f;
        float startSpriteOpacity = sprite.color.a;

        while (sprite.color.a != 1)
        {
            alpha += Time.deltaTime;

            newSpriteOpacity = Mathf.Lerp(startSpriteOpacity, 1f, lerpSpeed * alpha);
            Color newColor = new Color(sprite.material.color.r, sprite.material.color.g, sprite.material.color.b, newSpriteOpacity);
            sprite.color = newColor;

            yield return new WaitForEndOfFrame();
        }

        yield return null;
    }
}

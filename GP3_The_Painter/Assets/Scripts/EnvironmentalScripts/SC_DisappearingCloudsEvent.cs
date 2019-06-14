using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_DisappearingCloudsEvent : MonoBehaviour
{
    [Tooltip("This is the amount of movement on the x axis they move before disappearing")]
    public float cloudMovement = 5f;
    public float lerpSpeed = 0;
    SpriteRenderer cloudSprite;

    private void Start()
    {
        cloudSprite = GetComponent<SpriteRenderer>();
    }

    public void OnEventTriggered()
    {
        StartCoroutine(DisappearingClouds());
    }

    IEnumerator DisappearingClouds()
    {
        Vector3 startPos = transform.position;
        Vector3 targetPos = new Vector3(transform.position.x + cloudMovement, transform.position.y, transform.position.z);
        Vector3 newPos;
        float alpha = 0f;

        while (transform.position != targetPos)
        {
            alpha += Time.deltaTime;
            newPos = Vector3.Lerp(startPos, targetPos, lerpSpeed * alpha);
            transform.position = newPos;

            yield return new WaitForEndOfFrame();
        }

        //Color startColor = cloudSprite.color;
        //Color targetColor = new Color(1f, 1f, 1f, 0f);
        //Color newColor;
        //float colorAlpha = 0f;

        //while (cloudSprite.color != targetColor)
        //{
        //    colorAlpha += Time.deltaTime;
        //    newColor = Color.Lerp(startColor, targetColor, colorAlpha);
        //    cloudSprite.color = newColor;

        //    yield return new WaitForEndOfFrame();
        //}

        yield return null;
    }
}

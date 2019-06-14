using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_WeatherSpin : MonoBehaviour
{
    [Tooltip("Place Plane you want to spin with a SPRITE RENDERER")]
    public SpriteRenderer wetherSprite;
    public float spinSpeed = 0;
    public float maxRot = 0; 

    private Vector3 newRotation = new Vector3(0f, 0f, 0f);

    void Start()
    {
        newRotation = wetherSprite.transform.eulerAngles;
        maxRot -= spinSpeed;
    }

    public void OnEventTriggered()
    {
        StartCoroutine(RotateSprite());
    }

    IEnumerator RotateSprite()
    {
        while (newRotation.z <= maxRot)
        {
            newRotation.z += spinSpeed;
            wetherSprite.transform.eulerAngles = newRotation;

            yield return new WaitForEndOfFrame();
        }

        yield return null;
    }
}

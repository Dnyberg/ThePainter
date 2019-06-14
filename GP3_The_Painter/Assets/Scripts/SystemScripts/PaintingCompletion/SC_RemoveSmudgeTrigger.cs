using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

public class SC_RemoveSmudgeTrigger : MonoBehaviour
{
    [HideInInspector]
    public Renderer smudge = null;
    Player3DController myPlayer;
    SC_EnvironmentalEvent environmentalEvent;
    AudioSource removeSmudgeSound;

    private void Start()
    {
        myPlayer = GameObject.Find("3DPlayer")?.GetComponent<Player3DController>();

        environmentalEvent = GetComponent<SC_EnvironmentalEvent>();
        if (environmentalEvent == null)
        {
            Debug.Log("Failed to find environmental event in: " + gameObject.name);
        }

        smudge = GetComponentInChildren<Renderer>();
        Assert.IsNotNull(smudge, "You must pass in a reference to the smudge sprite.");

        removeSmudgeSound = GetComponent<AudioSource>();
        Assert.IsNotNull(removeSmudgeSound, "You haven't added the remove smudge sound to the remove smudge trigger");

    }


    private void OnTriggerEnter(Collider other)
    {

        if (other.gameObject.name == "3DPlayer")
        {

            Collider collider = GetComponent<Collider>();
            Destroy(collider);

            Invoke("ActivateEvent", 1f);

            StartCoroutine(LerpSmudge());
            removeSmudgeSound.Play();

            myPlayer.playerControl.DisableControl = true;
            Invoke("ActivatePlayerMovement", 1.5f);

            //smudge.color = new Color(0f, 0f, 0f, 0f);


        }
    }

    private void ActivateEvent()

    {
        environmentalEvent.TriggerEvent();
    }

    public void OnEventTrigger()
    {
        StartCoroutine(LerpSmudge());
    }

    IEnumerator LerpSmudge()
    {

        float alpha = 0f;
        float newSmudgeOpacity = 0f;
        float startSmudgeOpacity = smudge.material.GetFloat("_Scale");
        yield return null;
        while (smudge.material.GetFloat("_Scale") != 0f)
        {
            alpha += Time.deltaTime * 0.75f;

            newSmudgeOpacity = Mathf.Lerp(startSmudgeOpacity, 0f, alpha);
            
            smudge.material.SetFloat("_Scale", newSmudgeOpacity);


            yield return new WaitForEndOfFrame();

        }


        yield return null;
    }


    void ActivatePlayerMovement()
    {
        myPlayer.playerControl.DisableControl = false;
    }

}

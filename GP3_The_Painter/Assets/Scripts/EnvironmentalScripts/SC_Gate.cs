using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_Gate : Interactable
{
    public GameObject gateDoor;
    public GameObject player;

    public float rotate = 0.1f;


    bool shouldRotate = false;

    Interactor interactor;

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject == player)
        {
            Debug.Log("Player entered");
            shouldRotate = true;
        }
    }


    private void Update()
    {

        if (!shouldRotate) return;

      
        gateDoor.transform.Rotate(new Vector3(0f, rotate, 0f), Space.Self);
    }

    public void OnInteraction()
    {
        shouldRotate = true;
    }
}

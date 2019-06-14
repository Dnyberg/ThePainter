using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_Platform : MonoBehaviour
{
    public GameObject blockPlayerCollision;
    public Collider checkPlayerCollision;
    public Collider playerCollision;
    public PlayerControl playerControl;

    public bool doesIntersectBlockPlayerCollision = false;

    private void Start()
    {
        blockPlayerCollision.SetActive(false);
        checkPlayerCollision = GetComponent<Collider>();
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.name == "3DPlayer")
        {
            playerCollision = other.GetComponent<Collider>();
            playerControl = other.GetComponent<PlayerControl>();
        }

        //blockPlayerCollision.SetActive(true);
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.name != "3DPlayer") return;

        if (!doesIntersectBlockPlayerCollision)
        {
            blockPlayerCollision.SetActive(true);
        }



        if (playerControl.Movement.y < -0.95f && playerControl.canDescendPlatform)
        {
            Debug.Log("Descends platform");
            playerControl.DescendPlatform();
            blockPlayerCollision.SetActive(false);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        blockPlayerCollision.SetActive(false);
    }

}

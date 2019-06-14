using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUp : MonoBehaviour
{
    private Player3DController myPlayer;
    Rigidbody myRB;

    private void Start()
    {
        myRB = GetComponent<Rigidbody>();
        myRB.constraints = RigidbodyConstraints.FreezeRotationZ | RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationY;

        myPlayer = GameManager.Instance.Player.GetComponent<Player3DController>();
    }

    private void Update()
    {
        OnPickUp();
        OnRealese();
    }

    private void OnPickUp()
    {
        float distance = Vector3.Distance(transform.position, myPlayer.transform.position);

        if (Input.GetKey("l") && distance < 6f)
        {
            GetComponent<BoxCollider>().enabled = false;
            GetComponent<Rigidbody>().useGravity = false;
            var center = myPlayer.transform.position;
            var offset = myPlayer.transform.right * 5f * (myPlayer.flipX ? -1 : 1);

            gameObject.transform.position = center + offset;
            gameObject.transform.parent = GameObject.Find("3DPlayer").transform;
        }
    }

    private void OnRealese()
    {
        if (!Input.GetKey("l"))
        {
            gameObject.transform.parent = null;
            GetComponent<Rigidbody>().useGravity = true;
            GetComponent<BoxCollider>().enabled = true;
        }
    }
}
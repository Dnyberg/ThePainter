using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_BranchHit : MonoBehaviour
{
    //Daniel Nyberg

    // This bool is only used to control the animations atm. But added it if there is more things we want to trigger on hit later on. 
    private bool hit = false;

    public Collider myCollider;

    private Animator myAnim;

    // Used if the branch has an apple that will fall down to the ground when the player triggers the collision with the branch
    private Rigidbody appleRB;


    void Start()
    {
        //myCollider = GetComponent<Collider>();
        myAnim = GetComponent<Animator>();
        appleRB = GetComponentInChildren<Rigidbody>();
    }

    void Update()
    {
        // Bool is used to controll the animation.
        myAnim.SetBool("Hit", hit);
    }

    // What happens when someting triggers the collision box.
    void OnTriggerEnter(Collider myCollider)
    {
        hit = true;
        // If there is no apple attachted to the branch nothing will happen. (I think)
        if (appleRB != null)
        {
        appleRB.isKinematic = false;

        }
    }

    // What happens when something exits the collision box.
    private void OnTriggerExit(Collider myCollider)
    {
        hit = false;
    }
}

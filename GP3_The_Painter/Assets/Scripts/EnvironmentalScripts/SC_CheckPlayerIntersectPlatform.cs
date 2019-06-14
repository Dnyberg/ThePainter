using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_CheckPlayerIntersectPlatform : MonoBehaviour
{
    public SC_Platform platformParent;



    private void OnTriggerExit(Collider other)
    {
        if (other.name == "3DPlayer") platformParent.doesIntersectBlockPlayerCollision = false; 
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.name == "3DPlayer") platformParent.doesIntersectBlockPlayerCollision = true;
    }
}

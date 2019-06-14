using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CS_Mouth : MonoBehaviour
{
    //Player3DController controller;
    CharacterController controller;
    float xValue = 0f;
    // Start is called before the first frame update
    void Start()
    {
        xValue = transform.localPosition.x;
        controller = GetComponentInParent<CharacterController>();
    }

    // Update is called once per frame
    void Update()
    {
        float xVelocity = controller.velocity.x;

        xVelocity = Mathf.RoundToInt(xVelocity);
        xVelocity = Mathf.Clamp(xVelocity, -1f, 1f);
       
        if (xVelocity != 0 && SC_PlayerState.currentState != PlayerState.DragPush && SC_PlayerState.currentState != PlayerState.PickUp)
        {
        transform.localPosition = new Vector3(xValue * xVelocity, 0f, 0f);

        }

    }


    void UpdateMouthPosition()
    {

    }
}

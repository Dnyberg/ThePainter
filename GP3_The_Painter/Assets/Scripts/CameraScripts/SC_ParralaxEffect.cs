using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_ParralaxEffect : MonoBehaviour
{
    CharacterController playerController;
    public float parallaxStrength = 1f;

    // Start is called before the first frame update
    void Start()
    {
        playerController = GameObject.Find("3DPlayer").GetComponent<CharacterController>();
    }

    void Update()
    {

        
        if (playerController.velocity.magnitude != 0f)
        {
           // Debug.Log("Character is moving");
            



            Vector3 newPosition = transform.position;

            

            newPosition.x += Time.deltaTime * Mathf.Clamp(playerController.velocity.x, -1f, 1f) * parallaxStrength;
            //newPosition.y += Time.deltaTime * Mathf.Clamp(playerController.velocity.y, 0f, 1f);

            transform.position = newPosition;
        }

    }
}

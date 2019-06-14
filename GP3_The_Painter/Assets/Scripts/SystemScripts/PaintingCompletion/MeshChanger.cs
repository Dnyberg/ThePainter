using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshChanger : MonoBehaviour
{
    public Material myMaterial;
    Renderer myRenderer;

    void Start()
    {
        myRenderer = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown("k"))
        {
            myRenderer.material = myMaterial;
        }
    }
}

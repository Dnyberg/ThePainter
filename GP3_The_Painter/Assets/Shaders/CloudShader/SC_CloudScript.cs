using UnityEngine;


public class SC_CloudScript : MonoBehaviour
{
    public int horizontalStackSize = 20;
    public float cloudHeight = 1f;
    public Mesh quadMesh;
    public Material cloudMaterial;
    float offset;

    public int layer;
    public Camera camera;
    private Matrix4x4 matrix;
    private Matrix4x4[] matrices;
    public bool castShadow = false;
    public bool useGpuInstancing = false;
  
    // Update is called once per frame
    void Update()
    {
        cloudMaterial.SetFloat("_midYValue", transform.position.y);
        cloudMaterial.SetFloat("_cloudHeight", cloudHeight);

        offset = cloudHeight / horizontalStackSize / 2f;
        Vector3 startPosition = transform.position + (Vector3.up * (offset * horizontalStackSize / 2f));

        if (useGpuInstancing) // intialize matrix array
        {
            matrices = new Matrix4x4[horizontalStackSize];
        }

        for (int i = 0; i < horizontalStackSize; i++)
        {
            matrix = Matrix4x4.TRS(startPosition - (Vector3.up * offset * i), transform.rotation, transform.localScale);

            if (useGpuInstancing)
            {
                matrices[i] = matrix; //Build the matrices array if using GPU instancing
            }
            else
            {
                Graphics.DrawMesh(quadMesh, matrix, cloudMaterial, layer, camera, 0, null, true, false, false); // Otherwise draw this
            }

            
        }

        if(useGpuInstancing) //draw the built matrix array
        {
            UnityEngine.Rendering.ShadowCastingMode shadowCasting = UnityEngine.Rendering.ShadowCastingMode.Off;
            if (castShadow)
            
                shadowCasting = UnityEngine.Rendering.ShadowCastingMode.On;
                Graphics.DrawMeshInstanced(quadMesh, 0, cloudMaterial, matrices, horizontalStackSize, null, shadowCasting, false, layer, camera);

            
        }
         
    }
}

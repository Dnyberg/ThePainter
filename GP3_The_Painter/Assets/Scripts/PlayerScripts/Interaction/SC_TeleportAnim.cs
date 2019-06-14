using UnityEngine;

[ExecuteInEditMode]
public class SC_TeleportAnim : MonoBehaviour
{

    public GameObject animationPrefab;

    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void SpawnAnim()
    {
        Instantiate(animationPrefab, transform.position, Quaternion.identity);

    }
}

using UnityEngine;
using UnityEngine.Events;

public class BasketPuzzle : MonoBehaviour
{
    public int Apples = 3;

    private int currentApples = 0;

    public UnityEvent OnComplete;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag != "Apple")
            return;

        Destroy(other.gameObject);
        currentApples++;

        if (currentApples >= Apples)
            OnComplete?.Invoke();
    }
}
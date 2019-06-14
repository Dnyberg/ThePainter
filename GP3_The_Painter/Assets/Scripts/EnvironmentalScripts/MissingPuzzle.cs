using System.Collections;
using UnityEngine;
using UnityEngine.Events;

// quick protoype to get something working
public class MissingPuzzle : MonoBehaviour
{
    /// <summary>
    /// The piece that is missing.
    /// </summary>
    public GameObject Piece;

    public UnityEvent OnComplete;

    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject != Piece)
            return;

        Debug.Log("Piece is back boys");

        OnComplete?.Invoke();

        StartCoroutine(Transfer());
    }

    IEnumerator Transfer()
    {
        while (!Mathf.Approximately(Vector3.Distance(transform.position, Piece.transform.position), 0f))
        {
            Piece.transform.position = Vector3.Lerp(Piece.transform.position, transform.position, 0.1f);

            yield return new WaitForEndOfFrame();
        }

        yield return null;
    }
}
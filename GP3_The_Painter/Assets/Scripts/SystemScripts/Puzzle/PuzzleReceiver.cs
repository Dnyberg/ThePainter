using UnityEngine;
using UnityEngine.Events;

public class PuzzleReceiver : MonoBehaviour
{
    public string Identifier;
    public UnityEvent OnReceived;

    public void Trigger() => OnReceived?.Invoke();
}
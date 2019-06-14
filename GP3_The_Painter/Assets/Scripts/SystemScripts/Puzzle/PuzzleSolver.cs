using UnityEngine;
using UnityEngine.Events;

public class PuzzleSolver : MonoBehaviour
{
    public string Identifier;
    [HideInInspector] public UnityEvent OnSolved;

    public void Trigger() => OnSolved?.Invoke();
}
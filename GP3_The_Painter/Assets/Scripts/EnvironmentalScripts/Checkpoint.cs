using UnityEngine;

// This is basically just a proxy script for the game manager to be used with triggers
// It should probably be less stupid
public class Checkpoint : MonoBehaviour
{
    /// <summary>
    /// Sets this as the current checkpoint.
    /// </summary>
    public void Activate() => GameManager.Instance.UpdateCheckpoint(this);
}
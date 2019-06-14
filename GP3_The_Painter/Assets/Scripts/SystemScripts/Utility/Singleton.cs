using UnityEngine;
 
/// <summary>
/// Describes a MonoBehaviour that should only have a single instance.
/// </summary>
public class Singleton<T> : MonoBehaviour where T : MonoBehaviour
{
    private static bool isDestroyed = false;
    private static object _lock = new object();
    private static T instance;
 
    /// <summary>
    /// Returns the singleton instance or creates a new one if one doesn't exist.
    /// </summary>
    public static T Instance
    {
        get
        {
            if (isDestroyed)
            {
                Debug.LogWarning($"Singleton instance \"{typeof(T)}\" was destroyed.");
                return null;
            }
 
            // Make sure we can't access this until we're done with it, avoids creating multiple instances through different threads
            lock (_lock)
            {
                if (instance == null)
                {
                    // If there is already an instance, we'll use it
                    instance = (T)FindObjectOfType(typeof(T));
 
                    // If an instance doesn't exist, create a new one
                    if (instance == null)
                    {
                        // Create a gameobject and attach the component to it
                        var obj = new GameObject()
                        {
                            name = $"{typeof(T)} (Singleton)"
                        };
                        instance = obj.AddComponent<T>();
 
                        // Make the singleton persistant
                        DontDestroyOnLoad(obj);
                    }
                }
 
                return instance;
            }
        }
    }
 
    private void OnApplicationQuit() => isDestroyed = true;
    private void OnDestroy() => isDestroyed = true;
}
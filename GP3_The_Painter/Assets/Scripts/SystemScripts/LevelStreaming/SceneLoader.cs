using UnityEngine;
using System.Collections.Generic;
using UnityEngine.SceneManagement;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.SceneManagement;
#endif

[System.Serializable]
public class SceneReference : ISerializationCallbackReceiver
{
#if UNITY_EDITOR
    // Allows us to select a scene asset in the inspector.
    [SerializeField] private SceneAsset asset = null;
#endif

    // Should only be modified during serialization.
    [SerializeField] private string path = string.Empty;

#if UNITY_EDITOR
    private bool IsAssetValid => asset != null;
#endif

    public string Path
    {
#if UNITY_EDITOR
        get => GetAssetPath();
        set
        {
            path = value;
            asset = GetSceneAsset();
        }
#else
        // Runtime relies on the stored path values
        get => path;
        set => path = value;
#endif
    }

    public void OnAfterDeserialize()
    {
#if UNITY_EDITOR
        EditorApplication.delayCall -= HandleBeforeDeserialize;
        EditorApplication.delayCall += HandleAfterDeserialize;
#endif
    }

    public void OnBeforeSerialize()
    {
#if UNITY_EDITOR
        EditorApplication.delayCall += HandleBeforeDeserialize;
#endif
    }

#if UNITY_EDITOR
    public string GetAssetPath()
    {
        if (asset == null)
            return null;

        return AssetDatabase.GetAssetPath(asset);
    }

    public SceneAsset GetSceneAsset()
    {
        if (string.IsNullOrEmpty(path))
            return null;

        return AssetDatabase.LoadAssetAtPath<SceneAsset>(path);
    }

    private void HandleAfterDeserialize()
    {
        // If the asset is valid, we don't need to do anything
        if (IsAssetValid)
            return;

        // We have a path we can get the scene asset from
        if (!string.IsNullOrEmpty(path))
        {
            asset = GetSceneAsset();

            // Invalid file path, reset to null
            if (asset == null)
                path = string.Empty;

            if (!Application.isPlaying)
                EditorSceneManager.MarkAllScenesDirty();
        }
    }

    private void HandleBeforeDeserialize()
    {
        // Asset is invalid but have Path to try and recover from
        if (IsAssetValid == false && string.IsNullOrEmpty(path) == false)
        {
            asset = GetSceneAsset();

            if (asset == null)
                path = string.Empty;

            EditorSceneManager.MarkAllScenesDirty();
        }
        // Asset takes precendence and overwrites Path
        else
        {
            path = GetAssetPath();
        }
    }
#endif
}

[ExecuteInEditMode]
public class SceneLoader : MonoBehaviour
{
    public List<SceneReference> Scenes = new List<SceneReference>();

    private void Start()
    {
#if UNITY_EDITOR
        foreach (var scene in Scenes)
        {
            if (!Application.isPlaying && !string.IsNullOrWhiteSpace(scene.Path))
                EditorSceneManager.OpenScene(scene.Path, OpenSceneMode.Additive);
        }
#else
        foreach (var scene in Scenes)
        {
            if (!string.IsNullOrWhiteSpace(scene.Path))
                SceneManager.LoadScene(scene.Path, LoadSceneMode.Additive);
        }
#endif
    }
}
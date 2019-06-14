using UnityEditor;
using UnityEngine;

[CanEditMultipleObjects]
[CustomEditor(typeof(Teleporter))]
public class TeleporterDrawer : Editor
{
    private SerializedProperty kScript;
    private SerializedProperty kTarget;
    private SerializedProperty kDestination;
    private SerializedProperty kForceGround;
    private Teleporter teleporter;

    private void OnEnable()
    {
        kScript = serializedObject.FindProperty("m_Script");
        kTarget = serializedObject.FindProperty("target");
        kDestination = serializedObject.FindProperty("destination");
        kForceGround = serializedObject.FindProperty("forceGround");

        teleporter = (Teleporter)target;
    }

    public override void OnInspectorGUI()
    {
        serializedObject.Update();

        EditorGUI.BeginDisabledGroup(true);
        EditorGUILayout.PropertyField(kScript);
        EditorGUI.EndDisabledGroup();

        EditorGUILayout.PropertyField(kTarget);
        EditorGUILayout.LabelField("OR", new GUIStyle
        {
            alignment = TextAnchor.MiddleCenter,
            normal = new GUIStyleState
            {
                textColor = Color.white
            }
        });
        EditorGUI.BeginDisabledGroup(kTarget.objectReferenceValue != null);
        EditorGUILayout.PropertyField(kDestination);
        EditorGUI.EndDisabledGroup();
        EditorGUILayout.PropertyField(kForceGround);

        serializedObject.ApplyModifiedProperties();
    }

    private void OnSceneGUI()
    {
        Handles.DrawDottedLine(teleporter.transform.position, teleporter.Destination, 1f);
    }
}

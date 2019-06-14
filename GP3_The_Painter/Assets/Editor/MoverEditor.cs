using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(Mover))]
public class MoverEditor : Editor
{
	private Mover mover;

	/// <summary>
	/// How many points we're calculating for the actual path.
	/// </summary>
	private const int resolution = 128;

	private void OnEnable()
	{
		if (target is Mover)
			mover = (Mover)target;
	}

	private void OnSceneGUI()
	{
		if (mover == null || mover.Path == null || mover.Path.Length <= 0)
			return;

		Vector3[] path;

		// The path is modified to use the selected space when playing
		// so we only have to do this ourselves if we're not playing
		if (!EditorApplication.isPlaying)
		{
			path = (Vector3[])mover.Path.Clone();

			if (mover.Space == Space.Self)
				for (int i = 0; i < path.Length; i++)
					path[i] += mover.transform.position;
		}
		else 
		{
			path = mover.Path;
		}
		
		// Calculate the actual path depending on the current motor
		if (mover.Motor != null)
		{
			for (int i = 0; i < resolution; i++)
			{
				var startTime = (i / (float)resolution);
				var endTime = ((i + 1) / (float)resolution);

				var start = mover.Motor.Evaluate(path, startTime);
				var end = mover.Motor.Evaluate(path, endTime);

				var color = Handles.color;
				
				Handles.color = Color.red;
				Handles.DrawLine(start, end);

				Handles.color = color;
			}
		}

		EditorGUI.BeginChangeCheck();

		var handles = new Vector3[path.Length];
		for (int i = 0; i < path.Length; i++)
		{
			var start = path[i];

			if (i < path.Length - 1)
			{
				var end = path[i + 1];
				Handles.DrawDottedLine(start, end, 1f);
			}

			Handles.Label(start, $"Position {i}");
			handles[i] = Handles.PositionHandle(start, Quaternion.identity);
		}

		if (EditorGUI.EndChangeCheck())
		{
			Undo.RecordObject(target, "Modified mover path");

			for (int i = 0; i < handles.Length; i++)
			{
				var position = handles[i];

				if (mover.Space == Space.Self)
					position -= mover.transform.position;

				mover.Path[i] = position;
			}
		}
	}
}
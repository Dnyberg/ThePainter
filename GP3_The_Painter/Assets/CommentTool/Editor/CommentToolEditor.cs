using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(CommentTool))]
public class CommentToolEditor : Editor
{
	CommentTool commentInfo;

	GUIStyle commentNameStyle;

	Texture2D foldoutExtended;
	Texture2D foldoutNotExtended;

	private void OnEnable()
	{
		commentInfo = (CommentTool)target;
		foldoutExtended = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/CommentTool/Textures/Foldout-extended.png", typeof(Texture2D));
		foldoutNotExtended = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/CommentTool/Textures/Foldout-not-extended.png", typeof(Texture2D));

		if (commentInfo.comments.Count == 0)
		{
			commentInfo.comments.Add(new Comment("Comment Name"));
		}
	}

	public override void OnInspectorGUI()
	{
		//------Custom style for headline------
		commentNameStyle = new GUIStyle(GUI.skin.textField);
		commentNameStyle.fontSize = 14;
		commentNameStyle.fontStyle = FontStyle.Bold;


		for (int i = 0; i < commentInfo.comments.Count; i++)
		{
			EditorGUI.BeginChangeCheck();

			EditorGUILayout.BeginVertical("box");

		//-----Begin headline box-------------
			EditorGUILayout.BeginHorizontal("box");

			Comment newComment = commentInfo.comments[i];
			bool removeComment = false;

				//------Foldout--------
			if (GUILayout.Button(newComment.foldoutComment ? foldoutExtended : foldoutNotExtended, GUILayout.ExpandWidth(false), GUILayout.ExpandHeight(true)))
			{
				newComment.foldoutComment = !newComment.foldoutComment;
			}
				//------End foldout----

			//------Name of comment-------
			newComment.name = GUILayout.TextField(newComment.name, commentNameStyle);

			//------Remove button---------
			removeComment = GUILayout.Toggle(removeComment, "Remove", GUILayout.ExpandWidth(false));

			EditorGUILayout.EndHorizontal();
		//-----End headline box---------------


			if (newComment.foldoutComment)
			{
				//The actual comment
				newComment.comment = GUILayout.TextArea(newComment.comment, GUILayout.MinHeight(200));
			}

			//To save/redo changes
			if (EditorGUI.EndChangeCheck())
			{
				Undo.RecordObject(commentInfo, "Change comment");

				commentInfo.comments[i] = newComment;
			}

			EditorGUILayout.EndVertical();

		
			//-----Make sure you can redo/save deletion of comments------

			if (removeComment)
			{
				EditorUtility.SetDirty(commentInfo);
				Undo.RecordObject(commentInfo, "Remove comment");

				commentInfo.comments.RemoveAt(i);
			}

			//----------------------------------------------------------

			GUILayout.Space(10);

		}



		//--------Add new comment button------------

		if (GUILayout.Button("Add New Comment"))
		{

			EditorUtility.SetDirty(commentInfo);
			Undo.RecordObject(commentInfo, "Add new comment");

			commentInfo.comments.Add(new Comment("Comment Name"));

		}



		GUILayout.Space(10);




		//--------Clear all comments button-------

		if (GUILayout.Button("Clear all comments"))
		{
			EditorUtility.SetDirty(commentInfo);
			Undo.RecordObject(commentInfo, "Clear all comments");

			commentInfo.comments.Clear();
			commentInfo.comments.Add(new Comment("Comment Name"));
		}

	}
}

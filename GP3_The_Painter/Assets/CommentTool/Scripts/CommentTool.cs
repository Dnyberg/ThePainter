using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class CommentTool : MonoBehaviour
{
	[HideInInspector]
	public List<Comment> comments = new List<Comment>();
}


[System.Serializable]
public struct Comment
{
	public string name;
	public string comment;
	public bool foldoutComment;

	public Comment(string Name, string Comment, bool FoldoutComment)
	{
		name = Name;
		comment = Comment;
		foldoutComment = FoldoutComment;
	}

	public Comment(string Name)
	{
		name = Name;
		comment = "";
		foldoutComment = true;
	}
}

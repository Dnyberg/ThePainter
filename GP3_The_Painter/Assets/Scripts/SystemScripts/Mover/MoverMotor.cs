using System;
using UnityEngine;

[Serializable]
public abstract class MoverMotor : ScriptableObject
{
    public abstract Vector3 Evaluate(Vector3[] path, float time);
}
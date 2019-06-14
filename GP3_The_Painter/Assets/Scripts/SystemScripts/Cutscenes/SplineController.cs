using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Threading;
using System.Threading.Tasks;

public struct SplineNode
{
    public Vector3 Position;
}

[AddComponentMenu("Splines/Spline Controller")]
[RequireComponent(typeof(SplineInterpolator))]
public class SplineController : MonoBehaviour
{
	public bool AutoStart = true;
	public bool AutoClose = true;
	public bool HideOnExecute = true;

	SplineInterpolator mSplineInterp;

	private void Awake()
	{
		mSplineInterp = GetComponent(typeof(SplineInterpolator)) as SplineInterpolator;
	}

    private void SetupSplineInterpolator(SplineInterpolator interp, SplineNode[] nodes, float duration)
    {
        interp.Reset();

        float step = (AutoClose) ? duration / nodes.Length : duration / (nodes.Length - 1);

        int c;
        for (c = 0; c < nodes.Length; c++)
            interp.AddPoint(nodes[c].Position, Quaternion.identity, step * c, new Vector2(0, 1));

        if (AutoClose)
            interp.SetAutoCloseMode(step * c);
    }

    public void FollowSpline(SplineNode[] nodes, Action callback = null, float duration = 5f)
    {
        if (nodes.Length <= 0)
            return;

        SetupSplineInterpolator(mSplineInterp, nodes, duration);
        mSplineInterp.StartInterpolation(callback != null ? new OnEndCallback(callback) : null, true);
    }

    //void OnDrawGizmos()
    //{
    //	Transform[] trans = GetTransforms();
    //	if (trans.Length < 2)
    //		return;

    //	SplineInterpolator interp = GetComponent(typeof(SplineInterpolator)) as SplineInterpolator;
    //	SetupSplineInterpolator(interp, trans);
    //	interp.StartInterpolation(null, false, WrapMode);

    //	Vector3 prevPos = trans[0].position;
    //	for (int c = 1; c <= 100; c++)
    //	{
    //		float currTime = c * Duration / 100;
    //		Vector3 currPos = interp.GetHermiteAtTime(currTime);
    //		float mag = (currPos-prevPos).magnitude * 2;
    //		Gizmos.color = new Color(mag, 0, 0, 1);
    //		Gizmos.DrawLine(prevPos, currPos);
    //		prevPos = currPos;
    //	}
    //}p
}
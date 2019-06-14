using UnityEngine;

/// <summary>
/// Applies bezier-curve movement to the mover.
/// </summary>
[CreateAssetMenu(menuName = "Mover Motor/Bezier")]
public class BezierMoverMotor : MoverMotor
{
    public override Vector3 Evaluate(Vector3[] path, float time)
    {
        time = Mathf.Clamp(time, 0f, 1f);

        return Bezier(time, path, 0, path.Length);
    }

    private Vector3 Bezier(float time, Vector3[] controlPoints, int index, int count)
    {
        if (count == 1) return controlPoints[index];

        var p0 = Bezier(time, controlPoints, index, count - 1);
        var p1 = Bezier(time, controlPoints, index + 1, count - 1);

        return new Vector3((1f - time) * p0.x + time * p1.x,
            (1f - time) * p0.y + time * p1.y,
            (1f - time) * p0.z + time * p1.z);
    }
}

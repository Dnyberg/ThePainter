using UnityEngine;

/// <summary>
/// Applies linear movement to the mover.
/// </summary>
[CreateAssetMenu(menuName = "Mover Motor/Linear")]
public class LinearMoverMotor : MoverMotor
{
    public override Vector3 Evaluate(Vector3[] path, float time)
    {
        time = Mathf.Clamp(time, 0f, 1f);

        if (path == null || path.Length <= 0)
            return Vector3.zero;

        if (time <= 0f || path.Length == 1)
            return path[0];

        if (time >= 1f)
            return path[path.Length - 1];

        var t = time * (path.Length - 1);
        var p = Mathf.FloorToInt(t);

        t -= p;

        return Vector3.Lerp(path[p], path[p + 1], t);
    }
}
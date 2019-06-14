using UnityEngine;

[CreateAssetMenu(menuName = "Mover Motor/Shadow")]
public class ShadowMoverMotor : MoverMotor
{
    public float Delay = 0.001f;
    public float Speed = 40f;
    public float Height = 1.5f;

    public override Vector3 Evaluate(Vector3[] path, float time)
    {
        time = Mathf.Clamp(time, 0f + Delay, 1f - Delay);

        if (path == null || path.Length <= 0)
            return Vector3.zero;

        if (/*time <= 0f || */path.Length == 1)
            return path[0];

        //if (time >= 1f)
        //    return path[path.Length - 1];

        var t = time * (path.Length - 1);
        var p = Mathf.FloorToInt(t);

        t -= p;

        var target = Vector3.Lerp(path[p], path[p + 1], t);
        target.y = path[0].y + Mathf.Sin(t * Speed) * Height;

        return target;
    }
}
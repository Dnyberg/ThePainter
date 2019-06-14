using UnityEngine;
using System.Collections.Generic;
using System;

// TODO: This is a pretty stupid name
public enum LoopType
{
    /// <summary>
    /// Moves from start to end and stops.
    /// </summary>
    None,

    /// <summary>
    /// Continuously moves through the path.
    /// </summary>
    Loop,

    /// <summary>
    /// Moves back and forth through the path.
    /// </summary>
    PingPong
}

public enum MotorType
{
    Linear,
    Bezier
}

public class Mover : MonoBehaviour
{
    [Tooltip("The motor that drives the movement.")]
    [SerializeField] public MoverMotor Motor;

    [Tooltip("What space the path is defined in.")]
    public Space Space = Space.Self;

    [Tooltip("In which way the cycle loops.")]
    public LoopType Loop = LoopType.None;

    [Tooltip("Defines the easing which will be applied to the movement.")]
    public AnimationCurve Ease = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

    [Tooltip("Time it takes for the mover to complete a cycle in seconds.")]
    public float Duration = 1f;

    [Tooltip("How long to hold the position at the ends of the cycle in seconds.")]
    public float HoldDuration = 0f;

    [Tooltip("Whether to automatically start moving.")]
    public bool AutoStart = false;

    [Tooltip("Path of the mover.")]
    public Vector3[] Path;

    /// <summary>
    /// Saves the original position of the mover.
    /// Relative position of the mover if <see cref="Space"/> is set to <see cref="Space.Self"/>.
    /// Used mainly for <see cref="MoverEditor"/>.
    /// </summary>
    public Vector3 StartPosition { get; private set; } = Vector3.zero;

    /// <summary>
    /// Whether the mover is moving backwards, will only be modified during <see cref="LoopType.PingPong"/>.
    /// </summary>
    public bool Reverse { get; private set; }
    public float Progress => Mathf.Clamp01(timer / Duration);
    public Vector3 CurrentPosition => Motor.Evaluate(Path, Ease.Evaluate(Progress));

    private bool isMoving = false;
    private float timer = 0f;
    private float pauseTimer = 0f;

    private void Awake()
    {
        StartPosition = transform.position;

        // Create a linear motor by default
        if (Motor == null)
            Motor = ScriptableObject.CreateInstance<LinearMoverMotor>();

        // If Ease is undefined, set to ease-in-out
        if (Ease == null)
            Ease = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

        // If we're in local space, we need to apply the position of the transform to the path
        if (Space == Space.Self)
            for (int i = 0; i < Path.Length; i++)
                Path[i] = StartPosition + Path[i];

        if (AutoStart)
            Move();
    }

    private void Update()
    {
        if ((!isMoving && pauseTimer <= 0f) || Motor == null)
            return;

        if (!isMoving && pauseTimer > 0f)
        {
            pauseTimer -= Time.deltaTime;

            if (pauseTimer <= 0f)
                Move();

            return;
        }

        if (Loop == LoopType.Loop)
        {
            if (timer >= Duration)
            {
                timer = 0f;

                if (HoldDuration > 0f)
                    Pause(HoldDuration);
            }
        }
        else if (Loop == LoopType.PingPong)
        {
            if (timer >= Duration)
            {
                Reverse = true;

                if (HoldDuration > 0f)
                    Pause(HoldDuration);
            }
            else if (timer <= 0f)
            {
                Reverse = false;

                if (HoldDuration > 0f)
                    Pause(HoldDuration);
            }
        }
        else
        {
            if (timer >= Duration)
                isMoving = false;
        }

        if (!Reverse)
            timer += Time.deltaTime;
        else
            timer -= Time.deltaTime;

        timer = Mathf.Clamp(timer, 0f, Duration);
        transform.position = CurrentPosition;
    }

    public void Move()
    {
        isMoving = true;
    }

    public void Pause(float time = -1f)
    {
        isMoving = false;
        pauseTimer = time;
    }

    public void Reset()
    {
        timer = 0f;
        transform.position = CurrentPosition;
    }
}

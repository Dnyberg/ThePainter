using System;
using System.Collections;
using UnityEngine;

public class ShadowController : MonoBehaviour
{
    [Tooltip("How long it takes for the shadow to walk up to the painting.")]
    [SerializeField] private float smudgeDuration = 4f;
    [Tooltip("How long the shadow waits while smudging the painting.")]
    [SerializeField] private float smudgeHold = 1f;
    [Tooltip("The shadows offset from the canvas when smudging.")]
    [SerializeField] private Vector3 smudgeOffset = Vector3.zero;

    [Tooltip("Called when the shadow is infront of the painting and should smudge it.")]
    public CustomEvent onSmudge;

    private Mover mover;
    private MoverMotor motor;
    private bool isSmudging;

    private void Awake()
    {
        mover = GetComponent<Mover>();
        motor = ScriptableObject.CreateInstance<LinearMoverMotor>();
    }

    private void Update()
    {
#if UNITY_EDITOR
        if (Input.GetKeyDown(KeyCode.T))
            Smudge();
#endif

        if (mover != null && !isSmudging)
        {
            transform.localScale = new Vector3(mover.Reverse ? -1f : 1f, 
                transform.localScale.y, transform.localScale.z);
        }
    }

    public void Smudge()
    {
        if (isSmudging)
            return;

        StartCoroutine(DoSmudge(GameManager.Instance.ActiveFrame.transform.position));
    }

    public void Reset()
    {
        mover.Reset();
    }

    IEnumerator DoSmudge(Vector3 position)
    {
        isSmudging = true;

        mover.Pause();

        var start = mover.CurrentPosition;
        //var end = new Vector3(position.x, start.y, start.z);
        var end = position + smudgeOffset;
        var path = new[] { start, end };
        var timer = 0f;

        while (timer < smudgeDuration)
        {
            timer += Time.deltaTime;

            var target = motor.Evaluate(path, Mathf.Clamp01(timer / smudgeDuration));
            var reverse = (target.x - transform.position.x) < 0f;
            transform.localScale = new Vector3(reverse ? 1f : -1f, transform.localScale.y, transform.localScale.z);
            transform.position = target;

            yield return new WaitForEndOfFrame();
        }

        onSmudge?.Invoke();
        yield return new WaitForSeconds(smudgeHold);

        timer = 0f;
        Array.Reverse(path);
        while (timer < smudgeDuration)
        {
            timer += Time.deltaTime;

            var target = motor.Evaluate(path, Mathf.Clamp01(timer / smudgeDuration));
            var reverse = (target.x - transform.position.x) < 0f;
            transform.localScale = new Vector3(reverse ? 1f : -1f, transform.localScale.y, transform.localScale.z);
            transform.position = target;

            yield return new WaitForEndOfFrame();
        }

        mover.Move();

        isSmudging = false;
    }
}
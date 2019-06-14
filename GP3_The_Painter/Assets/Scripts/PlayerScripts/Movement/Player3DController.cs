using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class Player3DController : MonoBehaviour
{
    [Header("Movement")]
    public float maxWalkSpeed = 30f;
    public float dragPushWalkSpeed = 20f;
    public bool canMove = true;

    [Header("Jump")]
    public float jumpHeight = 100f;
    public float gravitaion = 400f;
    [Tooltip("The speed of the player when jumping. The higher the number the longer the player jumps. Looks wierd if it's too high")]
    public float forwardMomentum = 40f;
    [Tooltip("Coyote time. This is how much time the player have to jump after leaving the platform. 'Saftey mode'")]
    public float graceTime = 1f;

    [Header("Animation")]
    [Tooltip("Modifies the speed of the walk ANIMATION, a lower value increases the speed of the ANIMATION.")]
    [Range(0.1f, 50f)]
    public float walkAnimationModifier = 7f;

    [Header("Teleporter")]
    [HideInInspector] public Teleporter teleporterRef;
    [HideInInspector] public bool isTeleporting = false;

    [HideInInspector]
    public float velocity = 0f;
    public bool flipX { get; private set; } = false;

    private Rigidbody rb;
    private Collider myCollider;
    private Animator myAnim;
    [HideInInspector]
    public CharacterController controller;

    [HideInInspector]
    public bool isJumping;
    private bool jumpPressed;

    public GameObject teleportAnim;
    private float verticalVelocity;
    private float slopeForce = 4000f;
    private float slopeForceRayLength = 5f;
    private float gravity = 400f;
    private float graceTimer = 0f;

    private float moveHorizontal;
    private float walkSpeed = 30f;

    private Vector3 moveDirection;
    private Vector3 moveVector = Vector3.zero;
    [HideInInspector] public PlayerControl playerControl;
    public CustomEvent OnTeleportBegin;
    public CustomEvent OnTeleportEnd;
    public float teleportDelayInSec = 0f;

    GameObject childMesh;

    private SC_PlayerState playerState;

    void Awake()
    {
        playerControl = GetComponent<PlayerControl>();

        rb = GetComponent<Rigidbody>();

        myCollider = GetComponent<Collider>();
        myAnim = GetComponentInChildren<Animator>();
        controller = GetComponent<CharacterController>();
        childMesh = GameObject.Find("Mesh");
        playerState = GetComponent<SC_PlayerState>();

        walkSpeed = maxWalkSpeed;
        gravity = gravitaion;
        graceTimer = graceTime;
    }

    private void Start()
    {
        teleportAnim.SetActive(false);
        SC_PlayerState.OnDragPush += OnDragPush;
        SC_PlayerState.OnIdle += OnIdle;
        //Vector3 startLocalPosition = new Vector3(0, -2.5f, 0);
        //Vector3 endLocalPosition = new Vector3(0, 3.5f, 0);
        //childMesh.localPosition = Vector3.Lerp(startLocalPosition, endLocalPosition, 10000);
    }


    void Update()
    {

        velocity = controller.velocity.magnitude;

        playerControl.Movement = new Vector2(Input.GetAxisRaw("Horizontal"), playerControl.Movement.y);

        moveHorizontal = playerControl.Movement.x;
        //float moveVertical = Input.GetAxisRaw("Vertical");

        Walk();
        Jump();
        Flip();

        ///Set animation variables.
        myAnim.SetFloat("speed", Mathf.Abs(moveHorizontal) * walkSpeed /*+ Mathf.Abs(moveVertical) * maxWalkSpeed*/);
        myAnim.SetFloat("speedMultiplier", Mathf.Abs(moveHorizontal) * walkSpeed / walkAnimationModifier);

        if (SC_PlayerState.currentState == PlayerState.DragPush) return;
    }

    /// <summary>
    /// Checks to see if the player is on a slope or not. Too prevent bouncing
    /// </summary>
    private bool OnSlope()
    {
        if (controller.isGrounded == false)
            return false;


        RaycastHit hit;
        Debug.DrawRay(controller.transform.position, Vector3.down, Color.blue, controller.height / 2 * slopeForceRayLength);

        if (Physics.Raycast(controller.transform.position, Vector3.down, out hit, controller.height / 2 * slopeForceRayLength))
            if (hit.normal != Vector3.up)
                return true;


        return false;
    }

    private void Gravity()
    {
        verticalVelocity = -gravity * Time.deltaTime;

    }

    private void Jump()
    {

        if (controller.isGrounded)
        {
            myAnim.SetBool("isJumping", false);
            Gravity();
            isJumping = false;
            graceTimer = graceTime;
            walkSpeed = maxWalkSpeed;
            jumpPressed = false;
        }
        else
        {
            verticalVelocity -= gravity * Time.deltaTime;
            myAnim.SetBool("isJumping", true);
            graceTimer -= Time.deltaTime;
            //moveVector.x = forwardMomentum;

        }

        if (playerControl.Jump && graceTimer > 0)
        {
            verticalVelocity = jumpHeight;
            myAnim.SetTrigger("takeOf");
            isJumping = true;
            graceTimer = 0;
            jumpPressed = true;
            //moveVector.x = forwardMomentum;

        }
        if (jumpPressed)
        {
            walkSpeed = forwardMomentum;
        }
    }

    private void Walk()
    {

        moveVector.x = moveHorizontal * walkSpeed;
        moveVector.y = verticalVelocity;
        //moveVector.z = moveVertical * 6f;
        controller.Move(moveVector * Time.deltaTime);

        //childMesh.localPosition = childMesh.localPosition + new Vector3(0, 0.025f, 0);

        ///Change gravity when on a slope to prevent bouncing. 
        if (moveHorizontal != 0 && OnSlope())
        {
            gravity = slopeForce;
        }
        if (OnSlope() == false)
        {
            gravity = gravitaion;
        }




        /*      if (Input.GetKey(KeyCode.LeftShift))
              {
                  walkSpeed = maxRunSpeed;
              }
              else
              {
                  walkSpeed = maxWalkSpeed;
              }*/
    }

    private void Flip()
    {
        if (moveHorizontal > 0)
        {
            flipX = false;
            jumpPressed = false;
            myAnim.transform.eulerAngles = new Vector3(0, 0, 0);
            teleportAnim.transform.eulerAngles = new Vector3(0, 0, 0);
        }
        else if (moveHorizontal < 0)
        {
            flipX = true;
            jumpPressed = false;
            myAnim.transform.eulerAngles = new Vector3(0, 180, 0);
            teleportAnim.transform.eulerAngles = new Vector3(0, 180, 0);
        }
    }

    /// <summary>
    /// Moves the character according to specified delta movement.
    /// </summary>
    public void Move(Vector3 delta) => controller.Move(delta);

    /// <summary>
    /// Moves the character to the specified position, taking collisions into account.
    /// </summary>
    /// <param name="position"></param>
    public void MoveTo(Vector3 position) => controller.Move(position - transform.position);

    /// <summary>
    /// Teleports the player to the location, ignoring collision between the points.
    /// </summary>
    public void Teleport(Vector3 position, float time = 0f)
    {
        StartCoroutine(Delay(position));
    }

    /// <summary>
    /// Forces the player down to the ground, useful when teleporting the player, so they don't spawn in the air.
    /// </summary>
    /// <param name="range">How far down we're allowed to move.</param>
    public void ForceGround(float range = 100f)
    {
        // TODO: Check prior to moving, instead of moving back and forth
        var previous = transform.position;
        var target = previous - Vector3.up * range;
        MoveTo(target);

        // If we ended up at the exact location, move back again, we didn't find ground
        if (Mathf.Approximately(Vector3.Distance(target, transform.position), 0f))
            Teleport(previous);
    }

    private void OnTriggerEnter(Collider other)
    {
        teleporterRef = other.gameObject.GetComponent<Teleporter>();

        if (other.gameObject.GetComponent<Teleporter>() && !teleporterRef.isDepth)
        {
            isTeleporting = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        teleporterRef = null;
        isTeleporting = false;
    }

    //Sets drag push walking speed
    private void OnDragPush()
    {
        walkSpeed = dragPushWalkSpeed;
        rb.isKinematic = true;
    }

    //resets to normal walking speed
    private void OnIdle()
    {
        walkSpeed = maxWalkSpeed;
        rb.isKinematic = false;
    }

    private void ActivatePlayerMovement()
    {
        teleportAnim.SetActive(false);
        playerControl.DisableControl = false;

        // HACK: This really shouldnt be here, but hey it works?
        OnTeleportEnd?.Invoke();
    }

    IEnumerator Delay(Vector3 position)
    {
        OnTeleportBegin?.Invoke();

        controller.enabled = false;
        playerControl.DisableControl = true;
        //yield return new WaitForSeconds(transitionAnimDelayInSec);
        teleportAnim.SetActive(true);
        // HACK: Character Delay between teleportation
        yield return new WaitForSeconds(teleportDelayInSec);
        transform.position = position;
        controller.enabled = true;
        // HACK: Anim & Character Delay to deactivate
        Invoke("ActivatePlayerMovement", 1.6f);
    }
}
using UnityEngine;
using UnityEngine.Experimental.Rendering;

public class GameManager : Singleton<GameManager>
{
    /// <summary>
    /// Reference to the player.
    /// </summary>
    public GameObject Player { get; private set; }

    /// <summary>
    /// Reference to the shadow.
    /// </summary>
    public GameObject Shadow { get; private set; }

    /// <summary>
    /// Reference to the current camera.
    /// </summary>
    public Camera ActiveCamera { get; private set; }

    /// <summary>
    /// Reference to the current frame.
    /// </summary>
    public SC_Frame ActiveFrame { get; private set; }

    /// <summary>
    /// Reference to the current checkpoint.
    /// </summary>
    public Checkpoint ActiveCheckpoint { get; private set; }

    /// <summary>
    /// Position of the player on the active frame.
    /// </summary>
    public Vector3 PlayerFramePosition { get; private set; }

    [Tooltip("Size of the active frame render target.")]
    public int ActiveFrameResolution = 2048;

    [Tooltip("Size of inactive frame render targets.")]
    public int InactiveFrameResolution = 512;

    [Tooltip("Enables or disables dynamically changing the resolution of frames.")]
    public bool UseDynamicResolution = false;

    private void Awake()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
        Debug.Assert(Player != null, $"Couldn't find player, was the player tagged as \"Player\"?");

        Shadow = GameObject.FindGameObjectWithTag("Shadow");
        Debug.Assert(Shadow != null, $"Couldn't find shadow, was the shadow tagged as \"Shadow\"?");

        // Set all frames as inactive initially
        foreach (var area in FindObjectsOfType<SC_CameraArea>())
            SetCanvasResolution(area.frame, area.paintingCamera, InactiveFrameResolution);
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
            Application.Quit();

        if (Player == null || ActiveCamera == null || ActiveFrame == null)
            return;

        PlayerFramePosition = RelativeToCanvas(Player.transform.position, ActiveCamera, ActiveFrame);
    }

    public Vector3 RelativeToCanvas(Vector3 position, Camera camera, SC_Frame frame)
    {
        // We only want the distance in depth
        var distance = Mathf.Abs(camera.transform.position.z - position.z);

        // Calculate frustum size at distance
        var height = 2.0f * distance * Mathf.Tan(camera.fieldOfView * 0.5f * Mathf.Deg2Rad);
        var width = height * camera.aspect;

        // Position relative to camera
        var relative = position - camera.transform.position;

        // Normalize depending on frustum size, 0f is left/bottom, 1f is right/top
        relative = new Vector3(relative.x / width + 0.5f, relative.y / height + 0.5f, 0f);

        // Scale to canvas
        var size = frame.Collider.bounds.size;
        relative = new Vector3(relative.x * size.x - size.x / 2f, relative.y * (size.y * 2f) - size.y / 2f, 0f);
        relative += frame.transform.position;

        return relative;
    }

    public void UpdatePlayerArea(Camera camera, SC_Frame frame)
    {
        if (frame == ActiveFrame && camera == ActiveCamera)
            return;

        // Decrease previous canvas resolution
        SetCanvasResolution(ActiveFrame, ActiveCamera, InactiveFrameResolution);

        // Increase new canvas resolution
        SetCanvasResolution(frame, camera, ActiveFrameResolution);

        ActiveCamera = camera;
        ActiveFrame = frame;
    }

    private void SetCanvasResolution(SC_Frame frame, Camera camera, int resolution)
    {
        if (!UseDynamicResolution)
            return;

        var renderer = frame?.GetComponent<Renderer>();

        if (renderer == null || camera == null)
            return;

        if (camera.targetTexture != null)
            camera.targetTexture.Release();

        camera.targetTexture = new RenderTexture(resolution, resolution, 0, GraphicsFormat.R8G8B8A8_UNorm);
        renderer.material.mainTexture = camera.targetTexture;
    }

    public void UpdateCheckpoint(Checkpoint checkpoint) => ActiveCheckpoint = checkpoint;

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        Gizmos.DrawWireSphere(PlayerFramePosition, 0.1f);
    }
#endif
}
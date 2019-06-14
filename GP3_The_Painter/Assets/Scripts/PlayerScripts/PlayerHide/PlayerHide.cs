using Spine.Unity;
using System.Collections;
using System.Threading;
using UnityEngine;

public class PlayerHide : MonoBehaviour
{
    public bool IsHiding { get; private set; } = false;
    public int layerNumber;
    /// <summary>
    /// The name of the skin to be used when hiding.
    /// </summary>
    [SerializeField] private string hiddenSkinName = string.Empty;
    private string defaultSkinName = string.Empty;
    private SkeletonMecanim mecanim;
    private new Light light;

    private void Awake()
    {
        mecanim = GetComponentInChildren<SkeletonMecanim>();
        light = GetComponentInChildren<Light>();

        if (mecanim == null || mecanim.Skeleton == null || mecanim.Skeleton.Skin == null)
            return;

        defaultSkinName = mecanim.Skeleton.Skin.name;
    }

    private void Update()
    {
        IsHiding = Input.GetAxisRaw("Vertical") < 0f || Input.GetButton("Hide");

        if (mecanim == null || mecanim.Skeleton == null || mecanim.Skeleton.Skin == null)
            return;

        if (IsHiding)
        {
            if (mecanim.Skeleton.Skin.name != hiddenSkinName && !string.IsNullOrWhiteSpace(hiddenSkinName))
                mecanim.Skeleton.SetSkin(hiddenSkinName);

            if (light != null)
                light.enabled = false;
        }
        else
        {
            if (mecanim.Skeleton.Skin.name != defaultSkinName && !string.IsNullOrWhiteSpace(defaultSkinName))
                mecanim.Skeleton.SetSkin(defaultSkinName);

            if (light != null)
                light.enabled = true;
        }
    }

    //private void OnTriggerEnter(Collider other)
    //{
    //    if (other.gameObject.layer == layerNumber)
    //    {
    //        IsHiding = true;
    //    }
    //}

    //private void OnTriggerExit(Collider other)
    //{
    //    IsHiding = false;
    //}
}


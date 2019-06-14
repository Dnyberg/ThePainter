using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_DragPush : MonoBehaviour
{

    public void OnDragPush(Interactor interactor)
    {
        transform.parent = interactor.gameObject.transform;
    }

    public void OnDragPushEnd(Interactor interactor)
    {
        transform.SetParent(null);
    }


}

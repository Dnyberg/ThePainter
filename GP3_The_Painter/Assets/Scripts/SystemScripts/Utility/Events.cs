using System;
using UnityEngine;
using UnityEngine.Events;

/*
    Unity Events with generic parameters can't normally be serialized.
    Here we define proxy classes which can.

    CEvent/CustomEvent is also a proxy class, it allows us to fold events in the inspector,
    making them easier to work with.

    Source: https://github.com/DigitalMachinist/unity-utilities/tree/master/Assets/Utilities/Foldable%20Events
*/

// First we define a proxy class for the unity event.
[Serializable] public class UnityEventInteractor : UnityEvent<Interactor> { }
[Serializable] public class UnityEventGameObject : UnityEvent<GameObject> { }

// Then we define a second proxy class for our custom foldable event.
[Serializable] public class CustomEvent: CEvent { }
[Serializable] public class CustomEventInteractor : CEvent<UnityEventInteractor, Interactor> { }
[Serializable] public class CustomEventGameObject : CEvent<UnityEventGameObject, GameObject> { }

[Serializable]
public class CEvent
{
    [SerializeField] protected UnityEvent unityEvent;

    public virtual void Invoke() => unityEvent.Invoke();
    public virtual void AddListener(UnityAction action) => unityEvent.AddListener(action);
    public virtual void RemoveListener(UnityAction action) => unityEvent.RemoveListener(action);
    public int GetPersistentEventCount() => unityEvent.GetPersistentEventCount();
    public string GetPersistentMethodName(int index) => unityEvent.GetPersistentMethodName(index);
    public UnityEngine.Object GetPersistentTarget(int index) => unityEvent.GetPersistentTarget(index);
}

[Serializable]
public class CEvent<T, U> where T : UnityEvent<U>
{
    [SerializeField] protected T unityEvent;

    public virtual void Invoke(U argument) => unityEvent.Invoke(argument);
    public virtual void AddListener(UnityAction<U> action) => unityEvent.AddListener(action);
    public virtual void RemoveListener(UnityAction<U> action) => unityEvent.RemoveListener(action);
    public int GetPersistentEventCount() => unityEvent.GetPersistentEventCount();
    public string GetPersistentMethodName(int index) => unityEvent.GetPersistentMethodName(index);
    public UnityEngine.Object GetPersistentTarget(int index) => unityEvent.GetPersistentTarget(index);
}
using UnityEngine;
using System.Linq;
using System.Collections.Generic;
using System;

public static class GameObjectExtensions
{
    public static T GetInterface<T>(this GameObject gameObject) 
        where T : class
    {
        Type type = typeof(T);

        if (!type.IsInterface) 
        {
            Debug.LogError($"{type.ToString()} is not an interface.");
            return null;
        }
 
        return gameObject.GetComponents<Component>().OfType<T>().FirstOrDefault();
    }
 
    public static IEnumerable<T> GetInterfaces<T>(this GameObject gameObject) 
        where T : class
    {
        Type type = typeof(T);

        if (!type.IsInterface) 
        {
            Debug.LogError($"{type.ToString()} is not an interface.");
            return Enumerable.Empty<T>();
        }
 
        return gameObject.GetComponents<Component>().OfType<T>();
    }
}
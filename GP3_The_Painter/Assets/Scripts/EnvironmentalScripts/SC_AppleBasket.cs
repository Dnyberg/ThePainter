using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_AppleBasket : MonoBehaviour
{

    public GameObject[] inventory = new GameObject[5];

    public void AddItem(GameObject item)
    {

        bool itemAdded = false;

        //Finds the first open slot in the inventory
        for (int i = 0; i < inventory.Length; i++)
        {
            if (inventory [i] == null)
            {
                inventory[i] = item;
                Debug.Log(item.name + "was added");
                itemAdded = true;
                break;
            }

        }

        //inventory full
        if (!itemAdded)
        {
            Debug.Log("Inventory full");
        }
    }
}

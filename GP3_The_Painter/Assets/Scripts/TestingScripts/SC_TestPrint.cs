using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_TestPrint : MonoBehaviour
{
    public string printThis = "";


    public void Print()
    {

        Debug.Log(printThis);
    }
}

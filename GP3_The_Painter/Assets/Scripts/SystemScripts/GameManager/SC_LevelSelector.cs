using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum Levels
{
    DaughterPortrait,
    LoversBridge,
    AppleOfMyEye,
    Level3,
    Level4
}



public class SC_LevelSelector : MonoBehaviour
{
    public Levels startLevel = Levels.DaughterPortrait;
    GameObject player;

    private Vector3 startPos = Vector3.zero;

    void Start()
    {
        player = GameObject.Find("3DPlayer");


        switch (startLevel)
        {
            case Levels.DaughterPortrait:
                {
                    startPos = GameObject.Find("DaughterPortraitStartPosition").transform.position;
                    

                    break;
                }
            case Levels.LoversBridge:
                {
                    startPos = GameObject.Find("LoversBridgeStartPosition").transform.position;
                    break;
                }

            case Levels.AppleOfMyEye:
                {
                    startPos = GameObject.Find("AppleOfMyEyeStartPosition").transform.position;
                    break;
                }

            case Levels.Level3:
                {
                    startPos = GameObject.Find("Painting3StartPosition").transform.position;
                    break;
                }
            case Levels.Level4:
                {
                    startPos = GameObject.Find("Painting4StartPosition").transform.position;
                    break;
                }


        }

        player.transform.position = startPos;

    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            startPos = GameObject.Find("DaughterPortraitStartPosition").transform.position;
            SwitchLevel();
        }

        if (Input.GetKeyDown(KeyCode.F2))
        {
            startPos = GameObject.Find("LoversBridgeStartPosition").transform.position;
            SwitchLevel();
        }

        if (Input.GetKeyDown(KeyCode.F3))
        {
            startPos = GameObject.Find("AppleOfMyEyeStartPosition").transform.position;
            SwitchLevel();
        }

        if (Input.GetKeyDown(KeyCode.F4))
        {
            startPos = GameObject.Find("Painting3StartPosition").transform.position;
            SwitchLevel();
        }

        if (Input.GetKeyDown(KeyCode.F5))
        {
            startPos = GameObject.Find("Painting4StartPosition").transform.position;
            SwitchLevel();
        }
                
    }



    void SwitchLevel()
    {
        player.transform.position = startPos;
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class SC_TestMenu : MonoBehaviour
{
    public GameObject camera;
    public GameObject camera1;
    public GameObject camera2;
    public GameObject pauseMenu;
    public GameObject pauseFocus;
    private float timer = 5;
    private float time = 0;
    private bool pressed = false;
    public static bool paused = false;



    private void Start()
    {
        time = timer;
    }

    public void Press()
    {
        Animator anim = camera.GetComponent <Animator>();
        anim.SetTrigger("Trigger");
        print("Pressed");
        pressed = true;
        //gameObject.SetActive(false);
    }
    void Update()
    {
        if (pressed)
        {
            time -= Time.deltaTime;
            if (time <= 0)
            {
                print("Hej");
                camera1.SetActive(false);
                camera2.SetActive(true);
                pressed = false;
            }
        }
        if (Input.GetButtonDown("Cancel"))
        {
            if (paused)
            {
                Resume();
            }
            else
            {
                Pause();
            }
        }


    }

    public void Resume()
    {
        pauseMenu.SetActive(false);
        Time.timeScale = 1f;
        paused = false;
    }

    public void Pause()
    {
        pauseMenu.SetActive(true);
        Time.timeScale = 0f;
        paused = true;
        GameObject.Find("EventSystem").GetComponent<EventSystem>().SetSelectedGameObject(pauseFocus, null);
    }
}

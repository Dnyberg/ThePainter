using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class SC_MainMenu : MonoBehaviour
{

    public GameObject mainMenu;
    public GameObject pauseMenu;
    public GameObject optionsMenu;
    [Tooltip("Drag the button that is supposed to be higlighted when pause is pressed, preferably the resume button.")]
    public GameObject pauseFocus;
    [Tooltip("Drag the button that is supposed to be higlighted when options is pressed.")]
    public GameObject optionsFocus;
    [Tooltip("Drag the button that is supposed to be higlighted when main menu is pressed.")]
    public GameObject mainPlay;
    public GameObject mainCredits;
    public GameObject mainQuit;
    public GameObject playerControl;

    [Header("Cut Scene")]
    [Tooltip("Wait time until the cutscene is done. Should have the same time as the cutscene is long. ")]
    public GameObject cutSceneCamera;
    public GameObject mainCamera;
    public float timer = 12f;
    [Header("Buttons")]
    public Button play;
    public Button credits;
    public Button quit;

    private PlayerControl pController;

    private Animator csAnim;

    private bool paused = false;
    private bool startPressed = false;
    private bool menuActive = false;


    private float time = 0f;

    void Start()
    {
        time = timer;
        mainMenu.SetActive(true);
        menuActive = true;
        pController = playerControl.GetComponent<PlayerControl>();
        csAnim = cutSceneCamera.GetComponent<Animator>();
        Debug.Log("Start");
        pController.DisableControl = true;
        
    }

    public void StartButton()
    {
        Debug.Log("Start Game");
        csAnim.SetTrigger("Start");
        startPressed = true;
        menuActive = false;
        play.interactable = false;
        credits.interactable = false;
        quit.interactable = false;
    }
    public void Credits()
    {
        Animator playAnim = mainPlay.GetComponent<Animator>();
        Animator creditsAnim = mainCredits.GetComponent<Animator>();
        Animator quitAnim = mainQuit.GetComponent<Animator>();

        playAnim.SetTrigger("Fade");
        creditsAnim.SetTrigger("Fade");
        quitAnim.SetTrigger("Fade");
        GameObject.Find("EventSystem").GetComponent<EventSystem>().SetSelectedGameObject(optionsFocus, null);
    }

    public void QuitGame()
    {
        Debug.Log("Quit Game");
        Application.Quit();
    }

    public void Options()
    {
        mainMenu.SetActive(false);
        pauseMenu.SetActive(false);
        optionsMenu.SetActive(true);
        GameObject.Find("EventSystem").GetComponent<EventSystem>().SetSelectedGameObject(optionsFocus, null);
    }

    public void Back()
    {
        if (paused)
        {
            optionsMenu.SetActive(false);
            pauseMenu.SetActive(true);
            GameObject.Find("EventSystem").GetComponent<EventSystem>().SetSelectedGameObject(pauseFocus, null);
        }
        else
        {
            optionsMenu.SetActive(false);
            mainMenu.SetActive(true);
            GameObject.Find("EventSystem").GetComponent<EventSystem>().SetSelectedGameObject(mainPlay, null);
        }
    }

    public void Resume()
    {
        pauseMenu.SetActive(false);
        Time.timeScale = 1f;
        paused = false;
        pController.DisableControl = false;
    }

    public void Pause()
    {
        pauseMenu.SetActive(true);
        Time.timeScale = 0f;
        paused = true;
        GameObject.Find("EventSystem").GetComponent<EventSystem>().SetSelectedGameObject(pauseFocus, null);
        pController.DisableControl = true;
    }

    public void BackToMain()
    {
        SceneManager.LoadScene("Scenes/SN_Persistent");
    }

    void Update()
    {
        if (Input.GetButtonDown("Cancel"))
        {
            if (paused)
            {
                Resume();
            }
            else if (!menuActive)
            {
                Pause();

            }

        }

        if (startPressed)
        {
            time -= Time.deltaTime;
            if (time <= 0)
            {
                print("Hej");
                cutSceneCamera.SetActive(false);
                startPressed = false;
                pController.DisableControl = false;
            }
        }
    }
}

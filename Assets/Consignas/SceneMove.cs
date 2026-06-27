using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneMove : MonoBehaviour
{
    void Update()
    {
        // Flecha derecha -> siguiente escena
        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            int nextScene = SceneManager.GetActiveScene().buildIndex + 1;

            if (nextScene < SceneManager.sceneCountInBuildSettings)
            {
                SceneManager.LoadScene(nextScene);
            }
        }

        // Flecha izquierda -> escena anterior
        if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            int previousScene = SceneManager.GetActiveScene().buildIndex - 1;

            if (previousScene >= 0)
            {
                SceneManager.LoadScene(previousScene);
            }
        }
    }
}

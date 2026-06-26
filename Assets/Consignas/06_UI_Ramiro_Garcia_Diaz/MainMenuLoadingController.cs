using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class MainMenuLoadingController : MonoBehaviour
{
    [Header("Paneles")]
    [SerializeField] private GameObject welcomePanel;
    [SerializeField] private GameObject loadingPanel;

    [Header("Interfaz de carga")]
    [SerializeField] private Image progressBarFill;
    [SerializeField] private TMP_Text progressText;

    [Header("Simulación")]
    [SerializeField, Min(0.1f)]
    private float loadingDuration = 5f;

    [Tooltip("Controla la velocidad visual de la barra.")]
    [SerializeField]
    private AnimationCurve progressCurve =
        AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

    private bool isLoading;

    private void Start()
    {
        welcomePanel.SetActive(true);
        loadingPanel.SetActive(false);

        SetProgress(0f);
    }

    public void StartGame()
    {
        if (isLoading)
        {
            return;
        }

        StartCoroutine(SimulateLoading());
    }

    private IEnumerator SimulateLoading()
    {
        isLoading = true;

        // Cambiamos de la portada a la pantalla de carga.
        welcomePanel.SetActive(false);
        loadingPanel.SetActive(true);

        SetProgress(0f);

        float elapsedTime = 0f;

        while (elapsedTime < loadingDuration)
        {
            elapsedTime += Time.unscaledDeltaTime;

            // Progreso lineal entre 0 y 1.
            float normalizedTime =
                Mathf.Clamp01(elapsedTime / loadingDuration);

            // Hace que la barra acelere y frene suavemente.
            float visualProgress =
                progressCurve.Evaluate(normalizedTime);

            SetProgress(visualProgress);

            yield return null;
        }

        // Nos aseguramos de terminar exactamente en 100%.
        SetProgress(1f);

        isLoading = false;

        Debug.Log("Simulación de carga finalizada.");
    }

    private void SetProgress(float progress)
    {
        progress = Mathf.Clamp01(progress);

        if (progressBarFill != null)
        {
            progressBarFill.fillAmount = progress;
        }

        if (progressText != null)
        {
            int percentage =
                Mathf.RoundToInt(progress * 100f);

            progressText.text = $"{percentage}%";
        }
    }
}
using System.Collections;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class WakeUpPostProcess : MonoBehaviour
{
    [Header("Shader")]
    [SerializeField] private Shader postProcessShader;

    [Header("Wake Up")]
    [SerializeField, Range(0f, 1f)]
    private float wakeAmount = 0f;

    [SerializeField, Min(0.01f)]
    private float wakeDuration = 2.5f;

    [SerializeField]
    private bool playOnStart = true;

    [Header("Visual Settings")]
    [SerializeField, Range(0f, 1f)]
    private float minBrightness = 0.35f;

    [SerializeField, Range(0.001f, 0.2f)]
    private float slitSoftness = 0.04f;

    [SerializeField, Range(0f, 0.5f)]
    private float maxOpen = 0.5f;

    private Material postProcessMaterial;
    private Coroutine wakeRoutine;

    private static readonly int WakeAmountID =
        Shader.PropertyToID("_WakeAmount");

    private static readonly int MinBrightnessID =
        Shader.PropertyToID("_MinBrightness");

    private static readonly int SlitSoftnessID =
        Shader.PropertyToID("_SlitSoftness");

    private static readonly int MaxOpenID =
        Shader.PropertyToID("_MaxOpen");

    private void Awake()
    {
        wakeAmount = 0f;

        if (postProcessShader == null)
        {
            Debug.LogError(
                "No hay un shader asignado al post-process de despertar.",
                this
            );

            enabled = false;
            return;
        }

        if (!postProcessShader.isSupported)
        {
            Debug.LogError(
                "El shader de despertar no es compatible.",
                this
            );

            enabled = false;
            return;
        }

        postProcessMaterial = new Material(postProcessShader);
    }

    private void Start()
    {
        if (playOnStart)
        {
            TriggerWakeUp();
        }
    }

    private void Update()
    {
        // Para probar manualmente
        if (Input.GetKeyDown(KeyCode.R))
        {
            TriggerWakeUp();
        }
    }

    private void OnRenderImage(
        RenderTexture source,
        RenderTexture destination)
    {
        if (postProcessMaterial == null)
        {
            Graphics.Blit(source, destination);
            return;
        }

        postProcessMaterial.SetFloat(WakeAmountID, wakeAmount);
        postProcessMaterial.SetFloat(MinBrightnessID, minBrightness);
        postProcessMaterial.SetFloat(SlitSoftnessID, slitSoftness);
        postProcessMaterial.SetFloat(MaxOpenID, maxOpen);

        Graphics.Blit(source, destination, postProcessMaterial);
    }

    public void TriggerWakeUp()
    {
        if (wakeRoutine != null)
        {
            StopCoroutine(wakeRoutine);
        }

        wakeRoutine = StartCoroutine(WakeUpRoutine());
    }

    private IEnumerator WakeUpRoutine()
    {
        wakeAmount = 0f;

        float elapsed = 0f;

        while (elapsed < wakeDuration)
        {
            elapsed += Time.deltaTime;

            float normalizedTime =
                Mathf.Clamp01(elapsed / wakeDuration);

            wakeAmount = normalizedTime;

            yield return null;
        }

        wakeAmount = 1f;
        wakeRoutine = null;
    }

    private void OnDestroy()
    {
        if (postProcessMaterial != null)
        {
            Destroy(postProcessMaterial);
        }
    }
}
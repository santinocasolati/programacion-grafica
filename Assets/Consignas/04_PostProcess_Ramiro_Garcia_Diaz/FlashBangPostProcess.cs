using System.Collections;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class FlashBangPostProcess : MonoBehaviour
{
    public Shader flashShader;
    private Material flashMaterial;

    [Range(0f, 1f)]
    public float flashAmount = 0f;

    public float fadeDuration = 2f;

    private Coroutine flashRoutine;

    void Awake()
    {
        if (flashShader != null)
        {
            flashMaterial = new Material(flashShader);
        }
    }

    void Update()
    {
        // Solo para probar el efecto apretando una tecla
        if (Input.GetKeyDown(KeyCode.Q))
        {
            TriggerFlashBang();
        }
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (flashMaterial == null)
        {
            Graphics.Blit(source, destination);
            return;
        }

        flashMaterial.SetFloat("_FlashAmount", flashAmount);
        Graphics.Blit(source, destination, flashMaterial);
    }

    public void TriggerFlashBang()
    {
        if (flashRoutine != null)
            StopCoroutine(flashRoutine);

        flashRoutine = StartCoroutine(FlashRoutine());
    }

    IEnumerator FlashRoutine()
    {
        // Explosión instantánea
        flashAmount = 1f;

        float t = 0f;

        while (t < fadeDuration)
        {
            t += Time.deltaTime;
            flashAmount = 1f - Mathf.Clamp01(t / fadeDuration);
            yield return null;
        }

        flashAmount = 0f;
    }
}
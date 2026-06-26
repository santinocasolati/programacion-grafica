using System.Collections;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class DamageHealPostProcess : MonoBehaviour
{
    [Header("Shader")]
    [SerializeField] private Shader postProcessShader;

    [Header("Damage")]
    [SerializeField, Range(0f, 1f)]
    private float damageAmount = 0f;

    [SerializeField, Min(0.01f)]
    private float damageDuration = 1.5f;

    [SerializeField]
    private Color damageColor = Color.red;

    [Header("Healing")]
    [SerializeField, Range(0f, 1f)]
    private float healAmount = 0f;

    [SerializeField, Min(0.01f)]
    private float healDuration = 2.5f;

    [SerializeField]
    private Color healColor = new Color(0f, 1f, 0.25f, 1f);

    [Header("Vignette")]
    [SerializeField, Range(0f, 1f)]
    private float vignetteInner = 0.25f;

    [SerializeField, Range(0f, 1f)]
    private float vignetteOuter = 0.65f;

    [SerializeField, Min(0f)]
    private float pulseSpeed = 5f;

    private Material postProcessMaterial;

    private Coroutine damageCoroutine;
    private Coroutine healCoroutine;

    private static readonly int DamageAmountID =
        Shader.PropertyToID("_DamageAmount");

    private static readonly int HealAmountID =
        Shader.PropertyToID("_HealAmount");

    private static readonly int DamageColorID =
        Shader.PropertyToID("_DamageColor");

    private static readonly int HealColorID =
        Shader.PropertyToID("_HealColor");

    private static readonly int VignetteInnerID =
        Shader.PropertyToID("_VignetteInner");

    private static readonly int VignetteOuterID =
        Shader.PropertyToID("_VignetteOuter");

    private static readonly int PulseSpeedID =
        Shader.PropertyToID("_PulseSpeed");

    private void Awake()
    {
        damageAmount = 0f;
        healAmount = 0f;

        if (postProcessShader == null)
        {
            Debug.LogError(
                "No hay un shader asignado al post-process de daño y curación.",
                this
            );

            enabled = false;
            return;
        }

        if (!postProcessShader.isSupported)
        {
            Debug.LogError(
                "El shader de daño y curación no es compatible.",
                this
            );

            enabled = false;
            return;
        }

        postProcessMaterial = new Material(postProcessShader);
    }

    private void Update()
    {
        // Teclas de prueba.
        if (Input.GetKeyDown(KeyCode.W))
        {
            TriggerDamage();
        }

        if (Input.GetKeyDown(KeyCode.E))
        {
            TriggerHealing();
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

        postProcessMaterial.SetFloat(
            DamageAmountID,
            damageAmount
        );

        postProcessMaterial.SetFloat(
            HealAmountID,
            healAmount
        );

        postProcessMaterial.SetColor(
            DamageColorID,
            damageColor
        );

        postProcessMaterial.SetColor(
            HealColorID,
            healColor
        );

        postProcessMaterial.SetFloat(
            VignetteInnerID,
            vignetteInner
        );

        postProcessMaterial.SetFloat(
            VignetteOuterID,
            vignetteOuter
        );

        postProcessMaterial.SetFloat(
            PulseSpeedID,
            pulseSpeed
        );

        Graphics.Blit(
            source,
            destination,
            postProcessMaterial
        );
    }

    public void TriggerDamage()
    {
        StopHealingEffect();

        if (damageCoroutine != null)
        {
            StopCoroutine(damageCoroutine);
        }

        damageCoroutine = StartCoroutine(DamageRoutine());
    }

    public void TriggerHealing()
    {
        StopDamageEffect();

        if (healCoroutine != null)
        {
            StopCoroutine(healCoroutine);
        }

        healCoroutine = StartCoroutine(HealingRoutine());
    }

    private IEnumerator DamageRoutine()
    {
        damageAmount = 1f;

        float elapsed = 0f;

        while (elapsed < damageDuration)
        {
            elapsed += Time.deltaTime;

            float normalizedTime =
                Mathf.Clamp01(elapsed / damageDuration);

            damageAmount = 1f - normalizedTime;

            yield return null;
        }

        damageAmount = 0f;
        damageCoroutine = null;
    }

    private IEnumerator HealingRoutine()
    {
        healAmount = 0f;

        float elapsed = 0f;

        while (elapsed < healDuration)
        {
            elapsed += Time.deltaTime;

            float normalizedTime =
                Mathf.Clamp01(elapsed / healDuration);
            healAmount =
                Mathf.Sin(normalizedTime * Mathf.PI);

            yield return null;
        }

        healAmount = 0f;
        healCoroutine = null;
    }

    private void StopDamageEffect()
    {
        if (damageCoroutine != null)
        {
            StopCoroutine(damageCoroutine);
            damageCoroutine = null;
        }

        damageAmount = 0f;
    }

    private void StopHealingEffect()
    {
        if (healCoroutine != null)
        {
            StopCoroutine(healCoroutine);
            healCoroutine = null;
        }

        healAmount = 0f;
    }

    private void OnDestroy()
    {
        if (postProcessMaterial != null)
        {
            Destroy(postProcessMaterial);
        }
    }
}
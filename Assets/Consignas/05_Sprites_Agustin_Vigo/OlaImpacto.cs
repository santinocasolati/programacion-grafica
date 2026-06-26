using UnityEngine;

[RequireComponent(typeof(SpriteRenderer))]
public class OlaImpacto : MonoBehaviour
{
    [SerializeField] private float duracion = 0.6f;       // cuánto dura la ola
    [SerializeField] private float expansionX = 3f;       // cuánto se estira a lo ancho
    [SerializeField] private float expansionY = 0.5f;     // cuánto crece en alto (poco)
    [SerializeField] private AnimationCurve curvaAlpha = AnimationCurve.EaseInOut(0, 1, 1, 0);

    private SpriteRenderer sr;
    private Vector3 escalaInicial;
    private float tiempo;

    private void Awake()
    {
        sr = GetComponent<SpriteRenderer>();
        escalaInicial = transform.localScale;
    }

    private void Update()
    {
        tiempo += Time.deltaTime;
        float t = tiempo / duracion;

        // Crece hacia los costados (efecto de ola expandiéndose en ambos sentidos)
        transform.localScale = new Vector3(
            escalaInicial.x + expansionX * t,
            escalaInicial.y + expansionY * t,
            escalaInicial.z
        );

        // Se va desvaneciendo
        Color c = sr.color;
        c.a = curvaAlpha.Evaluate(t);
        sr.color = c;

        if (t >= 1f)
            Destroy(gameObject);
    }
}
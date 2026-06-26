using UnityEngine;

public class Flotador : MonoBehaviour
{
    [SerializeField] float nivelAgua = -2.5f;   // Y de la superficie (mismo valor que surfaceY)
    [SerializeField] float fuerzaEmpuje = 20f;   // qué tan fuerte flota
    [SerializeField] float amortiguacion = 2f;   // freno para que se asiente

    Rigidbody2D rb;

    void Start() { rb = GetComponent<Rigidbody2D>(); }

    void FixedUpdate()
    {
        // qué tan hundida está la pelota respecto de la superficie
        float profundidad = nivelAgua - transform.position.y;

        if (profundidad > 0f)   // está bajo el agua
        {
            // empuje hacia arriba proporcional a lo hundida que está
            rb.AddForce(Vector2.up * fuerzaEmpuje * profundidad);
            // freno para que no rebote eterno y se quede flotando
            rb.AddForce(-rb.velocity * amortiguacion);
        }
    }
}
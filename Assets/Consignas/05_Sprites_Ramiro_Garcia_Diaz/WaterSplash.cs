using UnityEngine;

public class WaterSplash : MonoBehaviour
{
    [SerializeField] ParticleSystem splashPrefab;
    [SerializeField] float surfaceY = 0f;

    void OnTriggerEnter2D(Collider2D other)
    {
        Debug.Log("ENTRÓ AL AGUA: " + other.name);  // ← test
        Splash(other);
    }

    void OnTriggerExit2D(Collider2D other) { Splash(other); }

    void Splash(Collider2D other)
    {
        Vector3 pos = new Vector3(other.transform.position.x, surfaceY, 0f);
        if (splashPrefab != null)
            Instantiate(splashPrefab, pos, Quaternion.identity);
    }
}
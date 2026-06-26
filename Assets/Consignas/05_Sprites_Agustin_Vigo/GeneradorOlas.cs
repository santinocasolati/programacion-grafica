using UnityEngine;

public class GeneradorOlas : MonoBehaviour
{
    [SerializeField] private GameObject prefabOla;
    [SerializeField] private string tagPelota = "Pelota";

    private void OnTriggerEnter2D(Collider2D other)
    {

        Debug.Log("Algo entró al trigger: " + other.name + " | tag: " + other.tag);
        if (other.CompareTag(tagPelota) && prefabOla != null)
        {
            // Z más negativo que el agua para que quede ADELANTE
            Vector3 pos = new Vector3(
                other.transform.position.x,
                transform.position.y+1,
                transform.position.z - 0.1f   // un poquito adelante del agua
            );
            Instantiate(prefabOla, pos, Quaternion.identity);
        }
    }
}
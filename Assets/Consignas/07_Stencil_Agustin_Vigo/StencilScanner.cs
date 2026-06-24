using UnityEngine;

public class StencilScanner : MonoBehaviour
{
    [SerializeField] Transform player;
    [SerializeField] float maxRadius = 25f;
    [SerializeField] float duration = 4f;          // cuánto dura 
    [SerializeField] KeyCode scanKey = KeyCode.Space;

    float timer;
    bool scanning;

    void Update()
    {
        transform.position = player.position;       

        if (Input.GetKeyDown(scanKey))
        {
            timer = 0f;
            scanning = true;
        }

        if (scanning)
        {
            timer += Time.deltaTime;

        
            float t = timer / duration;
            transform.localScale = Vector3.one * Mathf.Lerp(0f, maxRadius, t);

            if (timer >= duration)
            {
                scanning = false;
                transform.localScale = Vector3.zero;   
            }
        }
    }
}
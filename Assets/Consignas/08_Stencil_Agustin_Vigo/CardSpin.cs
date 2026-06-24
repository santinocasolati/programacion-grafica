using UnityEngine;

public class CardSpin : MonoBehaviour
{
    [SerializeField] float speed = 40f;
    void Update() => transform.Rotate(Vector3.up, speed * Time.deltaTime);
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMove : MonoBehaviour
{
    public float speed = 2f;

    void Update()
    {
        float movement = 0f;

        if (Input.GetKey(KeyCode.A))
            movement = -1f;

        if (Input.GetKey(KeyCode.D))
            movement = 1f;

        transform.position += Vector3.right * movement * speed * Time.deltaTime;
    }
}

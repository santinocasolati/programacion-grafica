using UnityEngine;

[ExecuteAlways]
public class WallDissolver : MonoBehaviour
{
    public Transform player;

    Material mat;

    void Start()
    {
        mat = GetComponent<Renderer>().material;
    }

    void Update()
    {
        mat.SetVector("_PlayerPos", player.position);
    }
}
using UnityEngine;

[ExecuteAlways]
public class WallDissolver : MonoBehaviour
{
    public Transform player;
    public float cutRadius = 2.5f;

    Material mat;

    void Start()
    {
        mat = GetComponent<Renderer>().material;
    }

    void Update()
    {
        mat.SetVector("_PlayerPos", player.position);
        mat.SetFloat("_CutRadius", cutRadius);
    }
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FloatingObjectsController : MonoBehaviour
{
    [Header("Meshes")]
    [SerializeField] private Mesh[] meshVariants;
    [SerializeField] private Mesh targetMesh;
    [SerializeField] private Material baseMaterial;
    [SerializeField] private Material targetMaterial;
    [SerializeField] private Color[] palette =
        {
            new Color(1f, 0.2f, 0.2f),
            new Color(0.2f, 0.8f, 1f),
            new Color(0.2f, 1f, 0.4f),
            new Color(1f, 0.85f, 0.1f),
            new Color(0.8f, 0.2f, 1f),
            new Color(1f, 0.5f, 0.1f),
        };

    [Header("Spawn")]
    [SerializeField] private int objectCount = 150;
    [SerializeField] private float spawnRadius = 40f;
    [SerializeField] private float minScale = 0.3f;
    [SerializeField] private float maxScale = 2.5f;

    [Header("Foto")]
    [SerializeField] private RenderTexture photoRenderTexture;
    [SerializeField] private RawImage photoDisplayUI;
    [SerializeField] private Camera photoCamera;

    [Header("Rotation")]
    [SerializeField] private Transform camerasContainer;
    [SerializeField] private float mouseSensitivity = 2f;

    private List<SpawnedObject> objects = new List<SpawnedObject>();
    private int targetIndex = -1;
    private bool photoTaken = false;
    private float yaw = 0f;
    private float pitch = 0f;

    private class SpawnedObject
    {
        public Mesh mesh;
        public Matrix4x4 matrix;
        public MaterialPropertyBlock props;
        public Vector3 position;
        public Quaternion rotation;
        public Vector3 scale;
        public Vector3 rotationAxis;
        public float rotationSpeed;
        public bool isTarget;
    }

    private void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
        photoDisplayUI.gameObject.SetActive(false);
        Populate();
    }

    private void Update()
    {
        RotateCamera();
        UpdateMatrices();
        DrawAll();

        if (!photoTaken && Input.GetMouseButtonDown(0))
            StartCoroutine(TakePhoto());
    }

    private void RotateCamera()
    {
        yaw += Input.GetAxis("Mouse X") * mouseSensitivity;
        pitch -= Input.GetAxis("Mouse Y") * mouseSensitivity;
        pitch = Mathf.Clamp(pitch, -89f, 89f);

        camerasContainer.rotation = Quaternion.Euler(pitch, yaw, 0f);
    }

    private void Populate()
    {
        objects.Clear();
        photoTaken = false;
        targetIndex = Random.Range(0, objectCount);

        for (int i = 0; i < objectCount; i++)
        {
            bool isTarget = (i == targetIndex);

            Vector3 pos = Random.insideUnitSphere * spawnRadius;
            pos.z = Mathf.Abs(pos.z) + 5f;

            float s = Random.Range(minScale, maxScale);
            Vector3 scale = Vector3.one * (isTarget ? s * 1.4f : s);
            Quaternion rot = Random.rotation;

            SpawnedObject obj = new SpawnedObject
            {
                position = pos,
                rotation = rot,
                scale = scale,
                rotationAxis = Random.onUnitSphere,
                rotationSpeed = Random.Range(20f, 90f) * (Random.value > 0.5f ? 1f : -1f),
                isTarget = isTarget,
                mesh = isTarget ? targetMesh : meshVariants[Random.Range(0, meshVariants.Length)],
                props = new MaterialPropertyBlock()
            };

            obj.props.SetColor("_Color", isTarget
                ? new Color(1f, 0.2f, 0.9f)
                : palette[Random.Range(0, palette.Length)]);

            obj.matrix = Matrix4x4.TRS(pos, rot, scale);
            objects.Add(obj);
        }
    }

    private void UpdateMatrices()
    {
        for (int i = 0; i < objects.Count; i++)
        {
            objects[i].rotation = Quaternion.Normalize(objects[i].rotation * Quaternion.AngleAxis(objects[i].rotationSpeed * Time.deltaTime, objects[i].rotationAxis));
            objects[i].matrix = Matrix4x4.TRS(objects[i].position, objects[i].rotation, objects[i].scale);
        }
    }

    private void DrawAll()
    {
        foreach (SpawnedObject obj in objects)
        {
            Graphics.DrawMesh(
                obj.mesh,
                obj.matrix,
                obj.isTarget ? targetMaterial : baseMaterial,
                0, null, 0,
                obj.props);
        }
    }

    private IEnumerator TakePhoto()
    {
        photoTaken = true;

        RenderTexture prevRT = photoCamera.targetTexture;
        photoCamera.targetTexture = photoRenderTexture;
        photoCamera.Render();
        photoCamera.targetTexture = prevRT;

        photoDisplayUI.texture = photoRenderTexture;
        photoDisplayUI.gameObject.SetActive(true);

        yield return new WaitForSeconds(3f);

        photoDisplayUI.gameObject.SetActive(false);
        Populate();
    }
}

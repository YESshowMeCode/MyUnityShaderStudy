using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

[RequireComponent(typeof(Camera))]

public class PostEffectsBase : MonoBehaviour {

    public Shader shader;
    private Material curMaterial;
    private Camera curCamera;

    public Camera camera
    {
        get
        {
            if (curCamera == null)
            {
                curCamera = transform.GetComponent<Camera>();
            }
            return curCamera;
        }
    }

    public Material material
    {
        get
        {
            if (curMaterial == null)
            {
                curMaterial = GenerateMaterial(shader);
            }
            return curMaterial;
        }
    }


    protected Material GenerateMaterial(Shader shader)
    {
        if(shader == null || !shader.isSupported)
        {
            Debug.Log("shader is null");
            return null;
        }

        Material material = new Material(shader);
        material.hideFlags = HideFlags.DontSave;

        return material;


    }
}

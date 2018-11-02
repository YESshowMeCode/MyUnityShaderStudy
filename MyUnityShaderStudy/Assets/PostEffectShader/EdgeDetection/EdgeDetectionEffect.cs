using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetectionEffect : PostEffectsBase
{
    [Range(0.0f, 1.0f)]
    public float edgeFactor = 0.5f;

    public Color edgeColor = Color.black;
    public Color backgroundColor = Color.white;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            material.SetFloat("edgeFactor", edgeFactor);
            material.SetVector("edgeColor", edgeColor);
            material.SetVector("backgroundColor", backgroundColor); 

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}

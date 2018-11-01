using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrainEffect : PostEffectsBase
{

    [Range(0, 20)]
    public int width = 10;

    [Range(0, 10)]
    public int height = 5;


    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            material.SetFloat("Width", width);
            material.SetFloat("Height", height);
            Graphics.Blit(source, destination, material);
        }
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RadialBlurEffect : PostEffectsBase
{
    [Range(0.0f, 0.05f)]
    public float blurSpread = 0.05f;

    public Vector2 BlurCenter = new Vector2(0.5f, 0.5f);


    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            material.SetVector("BlurCenter", BlurCenter);
            material.SetFloat("BlurSpread", blurSpread);

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        } 
    }



}

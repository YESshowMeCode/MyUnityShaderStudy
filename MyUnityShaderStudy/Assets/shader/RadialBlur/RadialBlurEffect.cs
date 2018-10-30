using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RadialBlurEffect : PostEffectsBase
{
    public Transform AnyOneTrans;
    [Range(0.0f, 0.1f)]
    public float BlurSpread = 0.001f;


    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            material.SetVector("AnyOneTrans", AnyOneTrans.position);
            material.SetFloat("BlurSpread", BlurSpread);

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        } 
    }



}

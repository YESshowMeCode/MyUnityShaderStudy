using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthOfFieldEffect : PostEffectsBase
{
    [Range(1, 5)]
    public int simpleDown = 2;

    [Range(1, 5)]
    public int iterator = 3;

    [Range(0.0f, 1.0f)]
    public float blurSpread = 0.5f;

    [Range(0.0f, 1.0f)]
    public float focusDistance = 0.5f;

    [Range(0.0f, 0.5f)]
    public float focusRange = 0.1f;

    //[Range(0.0f, 100.0f)]
    //public float nearBlurScale = 0.0f;

    //[Range(0.0f, 1000.0f)]
    //public float farBlurScale = 50.0f;

    void OnEnable()
    {
        camera.depthTextureMode |= DepthTextureMode.Depth;
    }


    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {

        if (material)
        {
            RenderTexture RT1 = RenderTexture.GetTemporary(source.width >> simpleDown, source.height >> simpleDown);
            RenderTexture RT2 = RenderTexture.GetTemporary(source.width >> simpleDown, source.height >> simpleDown);

            Graphics.Blit(source, RT1);

            for (int i = 0; i < iterator; ++i)
            {
                material.SetVector("BlurSpread", new Vector4(0, blurSpread, 0, 0));
                Graphics.Blit(RT1, RT2, material, 0);

                material.SetVector("BlurSpread", new Vector4(blurSpread, 0, 0, 0));
                Graphics.Blit(RT2, RT1, material, 0);

            }


            material.SetTexture("BlurTex", RT1);
            material.SetFloat("focusDistance", focusDistance);
            material.SetFloat("focusRange", focusRange);

            //material.SetFloat("nearBlurScale", nearBlurScale);
            //material.SetFloat("farBlurScale", farBlurScale);
            Graphics.Blit(source, destination, material, 1);

            RT1.Release();
            RT2.Release();
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }


    
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BloomEffect : PostEffectsBase
{
    [Range(0, 8)]
    public int sampleDown = 2;

    [Range(0,5)]
    public int iterator =4;

    [Range(0.0f, 1.0f)]
    public float blurSpread = 0.5f;

    [Range(0.0f, 1.0f)]
    public float bloomFactor = 0.5f;

    public Color bloomColor = Color.white;

    private Color colorThreshold = Color.gray;

     void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            RenderTexture RT1 = RenderTexture.GetTemporary(source.width >> sampleDown, source.height >> sampleDown);
            RenderTexture RT2 = RenderTexture.GetTemporary(source.width >> sampleDown, source.height >> sampleDown);

            Graphics.Blit(source, RT1);

            material.SetVector("colorThreshold", colorThreshold);
            Graphics.Blit(RT1, RT2, material, 0);

            material.SetVector("blurSpread", new Vector4(blurSpread,0,0,0));
            Graphics.Blit(RT2, RT1, material, 1);

            material.SetVector("blurSpread", new Vector4(0, blurSpread, 0, 0));
            Graphics.Blit(RT1, RT2, material, 1);

            material.SetTexture("blurTex", RT2);
            material.SetVector("bloomColor", bloomColor);
            material.SetFloat("bloomFactor", bloomFactor);

            Graphics.Blit(RT2, destination, material, 2);

            RT1.Release();
            RT2.Release();

        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

}

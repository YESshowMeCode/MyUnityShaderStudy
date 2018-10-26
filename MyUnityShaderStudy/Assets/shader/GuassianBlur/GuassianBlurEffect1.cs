using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuassianBlurEffect1 : PostEffectsBase
{
    [Range(1, 5)]
    public int iterators;
    [Range(0.0f, 1.0f)]
    public float guassianSpread;
    [Range(1, 5)]
    public int downSimple;


    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture RT1 = RenderTexture.GetTemporary(source.width >> downSimple, source.height >> downSimple);
        RenderTexture RT2 = RenderTexture.GetTemporary(source.width >> downSimple, source.height >> downSimple);

        Graphics.Blit(source, RT1);

        if(material)
        {
            for (int i = 0; i < iterators; ++i)
            {
                material.SetFloat("Offset", guassianSpread);
                Graphics.Blit(RT1, RT2, material, 0);
                Graphics.Blit(RT2, RT1, material, 1);
            }

            Graphics.Blit(RT1, destination);
            RT1.Release();
            RT2.Release();

        }
        else
        {
            Graphics.Blit(source, destination);
        }
        

    }

}

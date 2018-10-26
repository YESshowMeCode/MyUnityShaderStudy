using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]

public class GuassianBlurEffect : PostEffectsBase {

    [Range(1,5)]
    public int iterators = 4;
    [Range(0.0f,1.0f)]
    public float guassianSpread = 0.5f;
    [Range(1,5)]
    public int downSimple = 2;


    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {

        if (material)
        {
            RenderTexture RT1 = RenderTexture.GetTemporary(source.width >> downSimple, source.height >> downSimple);
            RenderTexture RT2 = RenderTexture.GetTemporary(source.width >> downSimple, source.height >> downSimple);

            Graphics.Blit(source, RT1);

            for(int i = 0; i < iterators; i++)
            {
                material.SetVector("Offset", new Vector4(guassianSpread, 0, 0, 0));
                Graphics.Blit(RT1, RT2, material);

                material.SetVector("Offset", new Vector4(0, guassianSpread, 0, 0));
                Graphics.Blit(RT2, RT1, material);
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

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DitherEffect : PostEffectsBase
{

    [Range(0.0f, 10.0f)]
    public float Size = 5.0f;


    private float ditherSpread ;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (ditherSpread > 0)
        {
            ditherSpread = -Size;
        }
        else
        {
            ditherSpread = Size;
        }

        if (material)
        {
            
            material.SetFloat("ditherSpread", ditherSpread);
            Graphics.Blit(source, destination, material);
        }    
    }

}

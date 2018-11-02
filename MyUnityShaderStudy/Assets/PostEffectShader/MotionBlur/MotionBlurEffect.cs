using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlurEffect : PostEffectsBase
{
    [Range(0.0f, 1.0f)]
    public float BlurAmount = 0.6f;

    private RenderTexture RTSave;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            if(RTSave==null || RTSave.height!= source.height || RTSave.width!= source.width)
            {
                DestroyImmediate(RTSave);
                RTSave = new RenderTexture(source.width, source.height, 0);
                RTSave.hideFlags = HideFlags.HideAndDontSave;
                Graphics.Blit(source, RTSave);
            }

            material.SetFloat("BlurAmount", BlurAmount);

            Graphics.Blit(source, RTSave, material);
            Graphics.Blit(RTSave, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

}

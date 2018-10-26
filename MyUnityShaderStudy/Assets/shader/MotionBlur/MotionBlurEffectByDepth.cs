using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlurEffectByDepth : PostEffectsBase
{
    [Range(0.0f, 1.0f)]
    public float BlurAmount = 0.05f;

    private Matrix4x4 preViewPrejectionMatrix;
    private Matrix4x4 preViewPrejectionToWorldMatrix;

    void OnEnable()
    {
        camera.depthTextureMode = DepthTextureMode.Depth;
        preViewPrejectionMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            material.SetFloat("BlurAmount", BlurAmount);
            material.SetMatrix("preViewPrejectionMatrix", preViewPrejectionMatrix);
            Matrix4x4 curViewPrejectionMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;
            Matrix4x4 curViewPrejectionToWorldMatrix = curViewPrejectionMatrix.inverse;
            material.SetMatrix("curViewPrejectionToWorldMatrix", curViewPrejectionToWorldMatrix);

            preViewPrejectionMatrix = curViewPrejectionMatrix;

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
        
    }





}

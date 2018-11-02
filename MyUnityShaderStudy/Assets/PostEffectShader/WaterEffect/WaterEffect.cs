using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterEffect : PostEffectsBase
{

    [Range(0.0f, 1.0f)]
    public float waveWidth = 0.5f;

    [Range(0.0f, 5.0f)]
    public float speed = 1.0f;

    [Range(10.0f, 100.0f)]
    public float distanceFactor = 60.0f;

    [Range(-100.0f, 0.0f)]
    public float timeFactor = -30.0f;

    [Range(0.0f, 2.0f)]
    public float sinFactor = 0.5f;

    private Vector4 startPos = new Vector4(0.5f, 0.5f, 0, 0);
    private float waveStartTime;
    private float curWaveDistance;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        curWaveDistance = (Time.time - waveStartTime) * speed;
        if (material)
        {
            material.SetFloat("waveWidth", waveWidth);
            material.SetFloat("distanceFactor", distanceFactor);
            material.SetFloat("curWaveDistance", curWaveDistance);
            material.SetVector("startPos", startPos);
            material.SetFloat("timeFactor", timeFactor);
            material.SetFloat("sinFactor", sinFactor);

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }


    private void Update()
    {
        if (Input.GetMouseButton(0))
        {
            Vector2 screenPos = Input.mousePosition;

            startPos = new Vector4(screenPos.x / Screen.width, screenPos.y / Screen.height, 0, 0);
            waveStartTime = Time.time;

        }
    }
}

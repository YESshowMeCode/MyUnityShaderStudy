using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TwirlEffect : PostEffectsBase
{


    public Vector2 radius = new Vector2(0.3F, 0.3F);
    public float angle = 0;
    public Vector2 center = new Vector2(0.5F, 0.5F);



    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        bool invertY = source.texelSize.y < 0.0f;
        if (invertY)
        {
            center.y = 1.0f - center.y;
            angle = -angle;
        }
        angle += Time.deltaTime * 200;

        if (material)
        {
            Matrix4x4 rotationMatrix = Matrix4x4.TRS(Vector3.zero, Quaternion.Euler(0, 0, angle), Vector3.one);

            material.SetMatrix("_RotationMatrix", rotationMatrix);
            material.SetVector("_CenterRadius", new Vector4(center.x, center.y, radius.x, radius.y));
            material.SetFloat("_Angle", angle * Mathf.Deg2Rad);
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}

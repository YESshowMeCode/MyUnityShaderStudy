Shader "Hidden/DepthOfFieldShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	CGINCLUDE
	#include "UnityCG.cginc"

	struct v2f_blur
	{
		float2 uv : TEXCOORD0;
		float4 uv1 : TEXCOORD1;
		float4 uv2 : TEXCOORD2;
		float4 uv3 : TEXCOORD3;
		float4 vertex : SV_POSITION;
	};

	struct v2f_DepthOfField
	{
		float2 uv : TEXCOORD0;
		float4 vertex : SV_POSITION;
	};

	sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	float4 BlurSpread;
	float focusDistance;
	sampler2D BlurTex;
	float nearBlurScale;
	float farBlurScale;
	sampler2D_float _CameraDepthTextrue;


	v2f_blur vert_blur (appdata_img v)
	{
		v2f_blur o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		BlurSpread *= _MainTex_TexelSize.xyxy;

		o.uv1 = v.texcoord.xyxy + BlurSpread * float4(1,1,-1,-1);
		o.uv2 = v.texcoord.xyxy + BlurSpread * float4(1,1,-1,-1) * 2;
		o.uv3 = v.texcoord.xyxy + BlurSpread * float4(1,1,-1,-1) * 3;

		return o;
	}
			

	fixed4 frag_blur (v2f_blur i) : SV_Target
	{
		fixed4 col = tex2D(_MainTex, i.uv) * 0.4;
		col += tex2D(_MainTex,i.uv1.xy) * 0.15;
		col += tex2D(_MainTex,i.uv1.zw) * 0.15;
		col += tex2D(_MainTex,i.uv2.xy) * 0.1;
		col += tex2D(_MainTex,i.uv2.zw) * 0.1;
		col += tex2D(_MainTex,i.uv3.xy) * 0.05;
		col += tex2D(_MainTex,i.uv3.zw) * 0.05;

		return col;
	}

	v2f_DepthOfField vert_depth(appdata_img v)
	{
		v2f_DepthOfField o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;

#if UNITY_UV_STARTS_AT_TOP
if (_MainTex_TexelSize.y < 0)
	o.uv.y = 1 - o.uv.y;
#endif	
return o;
	}

	float4 frag_depth(v2f_DepthOfField i): SV_Target
	{
		float4 blur = tex2D(BlurTex,i.uv);
		float4 origin = tex2D(_MainTex ,i.uv);

		float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTextrue,i.uv);
		depth = Linear01Depth(depth);

		float focalTest = clamp(sign(depth-focusDistance),0,1);
		float4 finalColor = (1 - focalTest) * origin + focalTest * lerp(origin, blur, clamp((depth - focusDistance) * farBlurScale, 0, 1));
		finalColor = (focalTest)* finalColor + (1 - focalTest) * lerp(origin, blur, clamp((focusDistance - depth) * nearBlurScale, 0, 1));
		return finalColor;
	}

	ENDCG

	SubShader
	{

		Pass
		{
			Cull Off ZWrite Off ZTest Always
			CGPROGRAM
			#pragma vertex vert_blur
			#pragma fragment frag_blur
			

			ENDCG
		}

		pass
		{
			Cull Off ZWrite Off ZTest Off
			ColorMask RGBA

			CGPROGRAM
			#pragma vertex vert_depth
			#pragma fragment frag_depth

			ENDCG

		}
	}
}

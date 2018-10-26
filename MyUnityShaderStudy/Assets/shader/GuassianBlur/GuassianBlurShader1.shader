Shader "Hidden/GuassianBlurShader1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	
	SubShader{
		CGINCLUDE

		#include "UnityCG.cginc"

		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float2 uv : TEXCOORD0;
			float2 uv1: TEXCOORD1;
			float2 uv2: TEXCOORD2;
			float2 uv3: TEXCOORD3;
			float2 uv4: TEXCOORD4;
			float4 vertex : SV_POSITION;
		
		};
		sampler2D _MainTex;
		float Offset;
		float4 _MainTex_TexelSize;

		v2f vert_V (appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);

			Offset *= _MainTex_TexelSize;	
		
			o.uv = v.uv;
			o.uv1 = v.uv + float2(0,1) * Offset;
			o.uv2 = v.uv + float2(0,-1) * Offset;
			o.uv3 = v.uv + float2(0,2) * Offset;
			o.uv4 = v.uv + float2(0,-2) * Offset;

			return o;
		}
	
		v2f vert_H (appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);

			Offset *= _MainTex_TexelSize;	
		
			o.uv = v.uv;
			o.uv1 = v.uv + float2(1,0) * Offset;
			o.uv2 = v.uv + float2(-1,0) * Offset;
			o.uv3 = v.uv + float2(2,0) * Offset;
			o.uv4 = v.uv + float2(-2,0) * Offset;

			return o;
		}
			

		fixed4 frag (v2f i) : SV_Target
		{
			float4 col = float4(0,0,0,0);
			col += tex2D(_MainTex, i.uv) * 0.5;
			col += tex2D(_MainTex, i.uv1) * 0.2;
			col += tex2D(_MainTex, i.uv2) * 0.2;
			col += tex2D(_MainTex, i.uv3) * 0.05;
			col += tex2D(_MainTex, i.uv4) * 0.05;

			return col;
		}
		ENDCG

		Cull Off ZWrite Off ZTest Always

		Pass{
			NAME "GAUSSIAN_BLUR_VERTICAL"
			CGPROGRAM
			#pragma vertex vert_V
			#pragma fragment frag

			ENDCG
		}
	
		Pass{
			NAME "GAUSSIAN_BLUR_HORIZONTAL"
			CGPROGRAM
			#pragma vertex vert_H
			#pragma fragment frag

			ENDCG
		}
		
	}
	FallBack "Diffuse"
}

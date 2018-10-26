Shader "Hidden/GuassianBlurShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 uv1: TEXCOORD1;
				float4 uv2: TEXCOORD2;
				float4 uv3: TEXCOORD3;
				float4 vertex : SV_POSITION;
			};

			float4 Offset;
			float4 _MainTex_TexelSize;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				Offset *= _MainTex_TexelSize.xyxy;

				o.uv1 = v.uv.xyxy + float4(1,1,-1,-1) * Offset;
				o.uv2 = v.uv.xyxy + float4(1,1,-1,-1) * Offset * 2.0;
				o.uv3 = v.uv.xyxy + float4(1,1,-1,-1) * Offset * 3.0;	
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				float4 col = float4(0,0,0,0);
				col += tex2D(_MainTex, i.uv) * 0.4;
				col += tex2D(_MainTex, i.uv1.xy) * 0.15;
				col += tex2D(_MainTex, i.uv1.zw) * 0.15;
				col += tex2D(_MainTex, i.uv2.xy) * 0.1;
				col += tex2D(_MainTex, i.uv2.zw) * 0.1;
				col += tex2D(_MainTex, i.uv3.xy) * 0.05;
				col += tex2D(_MainTex, i.uv3.zw) * 0.05;

				return col;
			}
			ENDCG
		}
	}
}

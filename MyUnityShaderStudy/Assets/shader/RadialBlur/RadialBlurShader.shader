Shader "Hidden/RadialBlurShader"
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
				float4 vertex : SV_POSITION;
			};
			sampler2D _MainTex;
			float BlurSpread;
			float3 AnyOneTrans;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				float4 worldpos = float4(AnyOneTrans.xyz,1);
				float4 screenPos = UnityObjectToClipPos(worldpos);
				float4 screenpos1 = mul(unity_CameraProjection,screenPos);

				float2 tmp = screenpos1.xy/screenpos1.w;
				float2 screenUV = (tmp.xy+1)/2;

				float2 dist = i.uv - screenUV;

				float k = dist.x/dist.y;

				float2 pos = float2(screenUV.x+BlurSpread*k,screenUV.y+BlurSpread );
				
				float4 col = tex2D(_MainTex, i.uv);
				float4 blurColor = tex2D(_MainTex, pos);

				float4 finalColor = (col + blurColor)/2;
				return finalColor;
			}
			ENDCG
		}
	}
}

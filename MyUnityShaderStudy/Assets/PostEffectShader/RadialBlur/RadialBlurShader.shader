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
			float4 BlurCenter;
			float4 _MainTex_TexelSize;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				#if UNITY_UV_STARTS_AT_TOP
					if (_MainTex_TexelSize.y < 0)
						o.uv.y = 1 - o.uv.y;
				#endif

				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{


				float2 dir = i.uv - BlurCenter.xy;
				float4 finalColor = 0;

				for(int j = 0 ; j < 5 ; ++j )
				{
					float2 uv = i.uv - dir * BlurSpread * j;				
					finalColor += tex2D(_MainTex,uv);
				}

				finalColor = finalColor/5;
				return finalColor;
			}
			ENDCG
		}
	}
}

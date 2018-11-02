Shader "Hidden/EdgeDetectionShader"
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
				float2 uv[9] : TEXCOORD0;


				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float edgeFactor;
			float4 edgeColor;
			float4 backgroundColor;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv[0] = v.uv + _MainTex_TexelSize.xy * float2(-1,1);
				o.uv[1] = v.uv + _MainTex_TexelSize.xy * float2(0,1);
				o.uv[2] = v.uv + _MainTex_TexelSize.xy * float2(1,1);
				o.uv[3] = v.uv + _MainTex_TexelSize.xy * float2(-1,0);
				o.uv[4] = v.uv + _MainTex_TexelSize.xy * float2(0,0);
				o.uv[5] = v.uv + _MainTex_TexelSize.xy * float2(1,0);
				o.uv[6] = v.uv + _MainTex_TexelSize.xy * float2(-1,-1);
				o.uv[7] = v.uv + _MainTex_TexelSize.xy * float2(0,-1);
				o.uv[8] = v.uv + _MainTex_TexelSize.xy * float2(1,-1);

				return o;
			}
			
			float luminance(float4 color){
				return  0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b; 
			}

			fixed4 frag (v2f i) : SV_Target
			{
				const float SobelX[9] = {-1,0,1,-2,0,2,-1,0,1};
				const float SobelY[9] = {-1,-2,-1,0,0,0,1,2,1};
				
				float luminnanceX = 0;
				float luminnanceY = 0;
				for(int j=0 ; j < 9 ;++j)
				{
					luminnanceX += luminance(tex2D(_MainTex,i.uv[j])) * SobelX[j];
					luminnanceY += luminance(tex2D(_MainTex,i.uv[j])) * SobelY[j];
				}
				float sobel = 1 - abs(luminnanceX) - abs(luminnanceY);
				
				float4 edgeOri = lerp(edgeColor , tex2D(_MainTex , i.uv[4]),sobel);
				float4 edgeBackground = lerp(edgeColor ,backgroundColor ,sobel);

				fixed4 col = lerp(edgeOri,edgeBackground,edgeFactor);

				return edgeOri;
			}
			ENDCG
		}
	}
}

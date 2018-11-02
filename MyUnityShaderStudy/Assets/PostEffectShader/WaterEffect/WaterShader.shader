Shader "Hidden/WaterShader"
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
			float4 _MainTex_TexelSize;
			float4 startPos;
			float waveWidth;
			float distanceFactor;
			float curWaveDistance;
			float timeFactor;
			float sinFactor;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				float2 toCenterVector = startPos.xy - i.uv;
				toCenterVector.y = toCenterVector.y * _MainTex_TexelSize.w / _MainTex_TexelSize.z;

				float dis = sqrt(toCenterVector.x* toCenterVector.x + toCenterVector.y*toCenterVector.y);
				float sinoffset = sin(dis * distanceFactor + _Time.y * timeFactor) * 0.01 * sinFactor;

				float discardFactor = clamp(waveWidth - abs(curWaveDistance - dis),0,1)/waveWidth;

				float2 disOffset = normalize(toCenterVector);

				float2 offsets = disOffset * discardFactor * sinoffset;

				float4 col = tex2D(_MainTex , i.uv + offsets);

				return col;
			}
			ENDCG
		}
	}
}

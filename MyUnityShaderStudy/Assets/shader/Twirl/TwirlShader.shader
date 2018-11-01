Shader "Hidden/VortexImageShader"
{
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
}
    SubShader { 
		ZTest Always Cull Off ZWrite Off
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD;
			};
			
			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD;
				float2 uvOrig : TEXCOORD1;
			};
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_TexelSize;
			half4 _MainTex_ST;
			uniform float4 _CenterRadius;
			uniform float _Angle;
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float2 uv = v.texcoord - _CenterRadius.xy;
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uvOrig = uv;
				return o;
			}
	
			half4 frag (v2f i) : SV_Target
			{
				float2 offset = i.uvOrig;
				float angleTmp = 1 - length(offset/_CenterRadius.zw);
				angleTmp = max(0,angleTmp);
				angleTmp = angleTmp * angleTmp * _Angle;
				float cosLength,sinLength;
				sincos(angleTmp,sinLength,cosLength);

				float2 uv;
				uv.x = cosLength * offset[0] - sinLength * offset[1];
				uv.y = sinLength * offset[0] + cosLength * offset[1];
				uv += _CenterRadius.xy;
				return tex2D(_MainTex, UnityStereoScreenSpaceUVAdjust(uv, _MainTex_ST));
			}
			ENDCG 
		} 
	}
	Fallback off

}

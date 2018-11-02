Shader "Hidden/MotionBlurByDepthShader"
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
				float2 depth : TEXCOORD1;
			};
			sampler2D _CameraDepthTexture;
			sampler2D _MainTex;
			float BlurAmount;
			float4x4 preViewPrejectionMatrix;
			float4x4 curViewPrejectionToWorldMatrix;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.depth = v.uv;
				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				float curdepth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.depth);

				float4 curScreenPosition = float4(i.uv.x*2-1, i.uv.y*2-1, curdepth*2-1 ,1);
				float4 curWorldPosition = mul(curViewPrejectionToWorldMatrix,curScreenPosition);

				float4 preScreenPosition = mul(preViewPrejectionMatrix,curWorldPosition);

				float2 preScreenUV = float2(preScreenPosition.x/preScreenPosition.w,preScreenPosition.y/preScreenPosition.w);

				float2 Speed = (curScreenPosition.xy - preScreenUV)/2.0f;

				float2 uv = i.uv;


				uv += Speed * BlurAmount;
				for(int i=1;i<10;++i,uv += Speed * BlurAmount){
					
					col += tex2D(_MainTex,uv);
				}

				col = col/10;

				return float4(col.rgb,1);
			}
			ENDCG
		}
	}
	FallBack Off
}

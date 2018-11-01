Shader "Hidden/BloomShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}

	CGINCLUDE
	#include "UnityCG.cginc"


	struct v2f_Treshold
	{
		float2 uv : TEXCOORD0;
		float4 vertex : SV_POSITION;
	};

	struct v2f_Blur
	{
		float2 uv : TEXCOORD0;
		float4 uv1 : TEXCOORD1;
		float4 uv2 : TEXCOORD2;
		float4 uv3 : TEXCOORD3;

		float4 vertex : SV_POSITION;
	};

	struct v2f_Bloom
	{
		float2 uv : TEXCOORD0;
		float4 vertex : SV_POSITION;
	};

	sampler2D _MainTex;
	sampler2D blurTex;
	float4 _MainTex_texelSize;
	float4 blurSpread;
	float4 bloomColor;
	float4 colorThreshold;
	float bloomFactor;

	v2f_Treshold vert_Treshold (appdata_img v)
	{
		v2f_Treshold o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	}
			

	fixed4 frag_Treshold (v2f_Treshold i) : SV_Target
	{
		fixed4 col = tex2D(_MainTex, i.uv);
		return saturate(col - colorThreshold);
	}


	v2f_Blur vert_Blur(appdata_img v)
	{
		v2f_Blur o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;

		blurSpread *= _MainTex_texelSize.xyxy;

		o.uv1 = v.texcoord.xyxy + blurSpread * float4(1,1,-1,-1);
		o.uv2 = v.texcoord.xyxy + blurSpread * float4(1,1,-1,-1) *2;
		o.uv3 = v.texcoord.xyxy + blurSpread * float4(1,1,-1,-1) *3;
		
		return o;
	
	}

	float4 frag_Blur(v2f_Blur i):SV_Target
	{
		float4 finalColor = 0;
		finalColor += tex2D(_MainTex,i.uv) * 0.4;
		finalColor += tex2D(_MainTex,i.uv1.xy) * 0.15;
		finalColor += tex2D(_MainTex,i.uv1.zw) * 0.15;
		finalColor += tex2D(_MainTex,i.uv2.xy) * 0.1;
		finalColor += tex2D(_MainTex,i.uv2.zw) * 0.1;
		finalColor += tex2D(_MainTex,i.uv3.xy) * 0.05;
		finalColor += tex2D(_MainTex,i.uv3.zw) * 0.05;

		return finalColor;
	}

	v2f_Bloom vert_Bloom(appdata_img v)
	{
		v2f_Bloom o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		
		return o;
	}

	float4 frag_Bloom(v2f_Bloom i):SV_Target
	{
		float4 origin = tex2D(_MainTex,i.uv);
		float4 blur = tex2D(blurTex,i.uv);

		origin += blur* bloomFactor * bloomColor;

		return origin;	
	}


	ENDCG
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_Treshold
			#pragma fragment frag_Treshold

			ENDCG
		}

		pass
		{
			CGPROGRAM
			#pragma vertex vert_Blur
			#pragma fragment frag_Blur

			ENDCG
		}

		pass
		{
			CGPROGRAM
			#pragma vertex vert_Bloom
			#pragma fragment frag_Bloom

			ENDCG
		
		}
	}
}

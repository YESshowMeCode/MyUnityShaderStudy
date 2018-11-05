Shader "Unlit/RimLightShader"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
		_RimColor("RimColor",Color) = (1,1,1,1)
		_RimFactor("RimFactor",Range(0.001,3.0)) = 0.1
		_MainTex("Main_Tex",2D) = "white" {}
	}
	SubShader
	{
		Tags { "LightMode"="ForwardBase" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float3 worldNormal : NORMAL;
				float4 pos : SV_POSITION;
				float3 worldViewDir : TEXCOORD0;
				float2 uv : TEXCOORD1;
			};

			float4 _Diffuse;
			float4 _RimColor;
			float _RimFactor;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert (appdata v)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);

				o.uv = TRANSFORM_TEX(v.uv , _MainTex);

				o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);

				float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

				o.worldViewDir = _WorldSpaceCameraPos.xyz - worldPos;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * _Diffuse;

				float3 worldNormal = normalize(i.worldNormal);

				float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				float3 lambert = 0.5 + dot(worldNormal , worldLightDir) * 0.5;

				float3 diffuse = _Diffuse.rgb * _LightColor0.rgb * lambert + ambient;

				float4 finalColor = tex2D(_MainTex, i.uv);

				float3 worldViewDir = normalize(i.worldViewDir);

				float Rim = 1- max(0 , dot(worldNormal , worldViewDir));

				float3 RimColor = _RimColor * pow(Rim , 1/_RimFactor);

				finalColor.rgb = finalColor.rgb * diffuse + RimColor;


				return finalColor;
			}
			ENDCG
		}
	}
}

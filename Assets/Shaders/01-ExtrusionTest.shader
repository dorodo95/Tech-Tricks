Shader "ShaderIntro/01/Pipe - Example"
{
	Properties
	{
		_Amount ("Extrusion Amount", Range(-1,1)) = 0.5
		_VertexColorMask ("Vertex Color Influence", Range (0,1)) = 1
		_GradTightness ("Gradient Tightness", float) = 1
	}
	SubShader
	{
		Tags 
		{ 
			"Queue" = "Transparent"
			"RenderType"="Transparent"
			"IgnoreProjector"="True" 
		}
		
		Blend SrcAlpha OneMinusSrcAlpha

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
				float3 normal: NORMAL;
				float4 color: COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float4 color: COLOR;
			};

			float _Amount;
			float _VertexColorMask;
			float _GradTightness;
			

			v2f vert (appdata v)
			{
				v2f o;  
				o.uv = v.uv;
				//parabola function: 4.0*x*(1.0-x)
				o.uv.y = pow(4 * frac(v.uv.y + (_Time * 20)) * frac(1 - (v.uv.y + (_Time * 20))),_GradTightness);
				
				//sets vertex offset and vertex color influence
				v.vertex.xyz += v.normal * (o.uv.y * _Amount) * lerp(1,(v.color),_VertexColorMask);
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.normal = v.normal;
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float viz = i.uv.y * lerp(1,i.color.r, _VertexColorMask) * (_Amount*2);
				float4 col = viz;
				col.a = i.color.a;

				return col;
			}
			ENDCG
		}
	}
}

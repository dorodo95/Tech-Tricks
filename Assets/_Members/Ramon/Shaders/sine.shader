Shader "Unlit/sine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MinSmooth("Min_Smooth", Range (0,2) ) = 0
        _MaxSmooth("Max_Smooth", Range (0,2) ) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Lightmode"="ForwardBase"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _MinSmooth;
            float _MaxSmooth;
            float pi = 3.141592653589793238462;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 lightDir = _WorldSpaceLightPos0;
                float lightRawMask = dot(i.normal, lightDir);
                float lightSine = sin(lightRawMask * (2*pi- asin(-_MinSmooth/_MaxSmooth))+(1-lightRawMask)* - asin(_MinSmooth/_MaxSmooth))*-_MaxSmooth;
                float lightGradient = (lightRawMask+ 1) /2;
                //float lightSmooth = smoothstep(_MinSmooth,_MaxSmooth,lightGradient);

                float4 light = _LightColor0 * lightSine;
                fixed4 col = tex2D(_MainTex, i.uv) * light;

                return col;
            }
            ENDCG
        }
    }
}

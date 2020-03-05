Shader "Unlit/lambert_blend_ambientlight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Diffuseness ("Diffuseness", float) = 1
        _AmbientPow ("Ambient_Pow", Range (0,1) ) = 1
        _MinSmooth("Min_Smooth", Range (0,1) ) = 0
        _MaxSmooth("Max_Smooth", Range (0,1) ) = 1
        _lightInfluence("Light Influence", Range (0,1) ) = 1
        _lightMixer("Mixer", Range (0,1) ) = 1
        _Steps("Steps", float ) = 1
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
                float3 specular : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 specular : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Diffuseness;
            float _AmbientPow;
            float _MinSmooth;
            float _MaxSmooth;
            float _lightInfluence;
            float _lightMixer;
            float _Steps;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal); 
                //float3 h = dot(_WorldSpaceCameraPos, _WorldSpaceLightPos0);
                //o.specular = dot(h, o.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                float3 lightDir = _WorldSpaceLightPos0;
                //float lightBW = step(0.5,pow((dot(i.normal, lightDir)+ 1) /2,_Diffuseness));
                float lightRawMask = dot(i.normal, lightDir);
                float lightGradient = pow((lightRawMask+ 1) /2,_Diffuseness);

                float lightSmooth = smoothstep(_MinSmooth,_MaxSmooth,lightGradient);
                float lightStep = (floor(lightSmooth * _Steps))/_Steps; 
                //float lightStep = lightSmooth;
                //float light

                //lightBW
                //lightMask
                
                float4 light = _LightColor0 * lightStep;               
                float4 lightAmbDark = light + unity_AmbientSky + ((_LightColor0 * 0.2 * _lightMixer));
                float4 lightAmb = lerp (lightAmbDark,light, lightStep * _AmbientPow);

                float decolorizedLightAmb = 0.21 * lightAmb.r + 0.71 * lightAmb.g + 0.07 * lightAmb.b;
                lightAmb = lerp(decolorizedLightAmb, lightAmb, _lightInfluence);

                fixed4 col =  tex2D(_MainTex, i.uv) * lightAmb;
                return col;
            }
            ENDCG
        }
    }
}

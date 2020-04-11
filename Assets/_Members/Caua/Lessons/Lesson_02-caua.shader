
Shader "Caua/Lesson_02"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Speed ("Speed", Range(0,100)) = 1
        _Step ("Step", Range(0,1)) = 0.1

    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 uv : TEXCOORD0;
            };

            fixed4 _Color;
            float _Speed;
            float _Step;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.uv - 0.5;
                o.uv.w = frac(_Time * _Speed + 0.5);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float dist = length(i.uv.xy * 2);
                float alpha = saturate(i.uv.w - (dist * 2));

                alpha = step(_Step , alpha);
                return fixed4(_Color.rgb, _Color.a * alpha);
            }
            ENDCG
        }
    }
}
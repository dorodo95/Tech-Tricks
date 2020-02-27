Shader "ShaderIntro/01/Ramon - Circle"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)

    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask RGB
        ZWrite Off
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"


            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
            };


            fixed4 _Color;
            fixed _circle;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.texcoord - 0.5;
                o.uv.z = frac(_Time * 5);
                o.uv.w = frac(_Time * 5 + 0.5);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float dist = length(i.uv.xy);
                float alpha_A = saturate(i.uv.z - (dist * 2)) ;
                float alpha_B = saturate(i.uv.w - (dist * 2)) ;

                float final_Alpha = alpha_A + alpha_B;
                final_Alpha = step(0.1, final_Alpha);
                return fixed4(_Color.rgb, _Color.a *final_Alpha);
            }
            ENDCG
        }
    }
}
Shader "Unlit/drawing_points"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 speed1 = i.uv + frac(_Time);
                float2 speed2 = i.uv + frac(_Time) * 0.2;
                float2 speed3 = i.uv + frac(_Time) * 0.4;
                float2 speed4 = i.uv + frac(_Time) * 0.6;
                float2 speed5 = i.uv + frac(_Time) * 0.8;


                float2 circle1Pos = speed1;
                float2 circle2Pos = speed2 + 0.2;
                float2 circle3Pos = speed3 - 0.2;
                float2 circle4Pos = float2(speed4.x - 0.2, speed4.y + 0.2);
                float2 circle5Pos = float2(speed5.x + 0.2, speed5.y - 0.2);

                float circle = step(distance(circle1Pos, 0.5), 0.1);
                float circle2 = step(distance(circle2Pos, 0.5), 0.02);
                float circle3 = step(distance(circle3Pos, 0.5), 0.02);
                float circle4 = step(distance(circle4Pos, 0.5), 0.02);
                float circle5 = step(distance(circle5Pos, 0.5), 0.02);

                fixed4 col = tex2D(_MainTex, i.uv);
                return circle + circle2 + circle3 + circle4 + circle5;
            }
            ENDCG
        }
    }
}

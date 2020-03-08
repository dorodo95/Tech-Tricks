Shader "Caua/Lesson_02"
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                //calls the v2f program "o"
                v2f o;
                //"o" vertex = converted the model vertex information "v" to screen coordinate
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = apply the uv transformations from _Maintex to v.uv
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // the uv only has coordinate input information, so it's necessarly a float2
                fixed4 texcol = tex2D(_MainTex, i.uv);
                fixed4 col = float4(i.uv.xy, 0, 1);
                col *= texcol;

                return col;
            }
            ENDCG
        }
    }
}

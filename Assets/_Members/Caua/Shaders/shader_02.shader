Shader "studies/shader_02"
{
    
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint_Color ("Tint Color", Color) = (0,0,0,0)
        _Transparency ("Transparency", Range(0.0, 1)) = 1
        _CutoutTresh ("Cutout Threshold", Range (0.0, 1)) = 0.2
        _Scale ("Scale", float) = 1
        
    }

    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100
        Cull off

        ZWrite on
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Tint_Color;
            float _Transparency;
            float _CutoutTresh;
            float _Scale;
         
            
            v2f vert (appdata v)
            {
                v2f o;
               // v.vertex =v.vertex * _Scale;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Tint_Color;
               // col.a = _Transparency;
               // clip (col.r - _CutoutTresh);

                return col;
            }
            ENDCG
        }
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
            float4 _Tint_Color;
            float _Transparency;
            float _CutoutTresh;
            float _Scale;
         
            
            v2f vert (appdata v)
            {
                v2f o;
                v.vertex =v.vertex * _Scale;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Tint_Color;
                clip (col.b - _CutoutTresh);
               

                return col;
            }
            ENDCG
        }    
    }
}

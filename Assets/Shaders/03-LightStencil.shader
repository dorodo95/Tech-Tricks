Shader "Unlit/LightStencil"
{
    Properties
    {
        _TintColor ("Light Color", Color) = (1, 0.2, 0, 0)
        _Brightness ("Brightness", Range(0, 2)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" }
        ZWrite Off
        Blend One One

        Pass
        {
            ColorMask 0
            ZTest Greater
            Cull Back

            Stencil
            {
                Ref 128
                Comp GEqual
                Pass Replace
                Fail IncrSat
            }
            
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
            };

            struct v2f
            {
                float4 vertex: SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            void frag()
            {
                //nothing to do here, we just want the stencil written
            }

            ENDCG
            
        }


        
        Pass
        {
            ColorMask RGBA
            Cull Front
            ZTest Greater

            Stencil
            {
                Ref 128
                Comp NotEqual
                Pass IncrSat
                Fail Zero
            }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float4 vertex: SV_POSITION;
                float3 normal: NORMAL;
            };
            
            fixed4 _TintColor;
            fixed _Brightness;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i): SV_Target
            {
                fixed4 col = fixed4(_TintColor) * _Brightness;
                return col;
            }
            ENDCG
            
        }
        
        
    }
}

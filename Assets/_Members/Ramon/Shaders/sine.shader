Shader "Unlit/sine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _A("A", float ) = 1
        _B("B", float ) = 1
        _T("T", float ) = 1
        _C("C", float ) = 1
        _D("Darkness", Range(0,1) ) = 1
        _Y("division", float) = 1
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
            float _A;
            float _B;
            float _T;
            float _C;
            float _D;
            float _Y;
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
                float lightSine = ((sin((lightRawMask/_T) * (2*pi- asin(-_A/_B))+(1-(lightRawMask/_T))* - asin(_A/_B))*-_B)+(_B*_D))/_Y + _C;
                //float lightGradient = (lightRawMask+ 1) /2;

                float4 light = _LightColor0 * lightSine;               
                float4 lightAmbDark = light + UNITY_LIGHTMODEL_AMBIENT;
                float4 lightAmb = lerp (lightAmbDark,light, lightSine);

                fixed4 col = tex2D(_MainTex, i.uv) * lightAmb;

                return col;
            }
            ENDCG
        }
    }
}

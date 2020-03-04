// name and path used in editor
Shader "studies/shader_unlit_explained"
{
    //properties used in editor
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
    }

    //A shader can have as many subshaders ans necessary
    //i.e. a subshader for each LOD 
    SubShader
    {
        
        Tags { "RenderType"="Opaque" }
        LOD 100

        // Many simple shaders use just one pass, but shaders that interact with lighting might need more
        // Commands inside Pass typically setup fixed function state, for example blending modes
        Pass
        {
            //CG program starts here and ends in "ENDCG", first we need to declare what components will be used (vertex, fragment, UnityCG.cginc, etc)
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            // unityCG.cging includes a bunch of usefull operations we can use
            #include "UnityCG.cginc"

            // struct is a structure of data we use to store information in a single variable 
            
            // struct appdata contains vertex position and uv0 texture coordinates (local space?)
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // struct v2f also contains uv0 texture coordinates and the vertex position in screen space (SV_POSITION)
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // These are properties we already exposed in the editor and will be used as input to the vertex and fragment programs in the folowing lines
            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            // here we will use the vertex information and process it
            // we are calling the "appdata" vertex information = "v" 
            // creating a new struct called "o"
            // vertex is being converted from local space to screen space by UnityObjectToClipPos
            // trasnforming the uv data
            // return the struct "o" result
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            // here we will acess the fragment (potential pixel) information and process it
            // here we are calling the "v2f" struct = "i" (as in "input")
            // creating a new struct called "col"
            // "i" is bound to the render target SV_Target (framebuffer from screen)
            // we are simply using the _MainTex information as input to the uv0 of our v2f (struct called "i" in this program), 
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                
                return col;
            }
            ENDCG
        }
    }
}

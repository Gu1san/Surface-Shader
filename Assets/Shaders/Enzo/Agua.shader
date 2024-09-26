Shader "Custom/Agua"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Velocity ("Velocity", Range(0,1)) = 0.0
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
         sampler2D _MainTex,_NoiseTex;
        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        half _Glossiness, _Velocity;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
            float time = float2(_Time.y, _Time.y) * _Velocity;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + time);
            float2 uv = IN.uv_MainTex + time;
            fixed4 noise = tex2D (_NoiseTex, uv);
            o.Albedo = c;
            o.Smoothness = _Glossiness;
            o.Normal = noise;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

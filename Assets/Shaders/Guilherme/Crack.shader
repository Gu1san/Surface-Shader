Shader "Custom/Crack"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        [HDR]_Emission ("Emission", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Radius("Raio do gradiente", Range(0, 1.0)) = 0.5
        _Center("Centro da textura", Range(0, 1.0)) = 0.5
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color, _Emission;
        float _Radius, _Center;

        //Como faço pra aplicar esse shader em um ponto específico de um objeto?
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = IN.uv_MainTex;
            float4 a = tex2D(_MainTex, uv);
            float2 center = uv - _Center;

            float centerDist = saturate(length(center) / _Radius);
            o.Albedo = a * _Color;
            o.Alpha = a * (1-centerDist);
            o.Emission = a * _Emission;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

Shader "Custom/Crack"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        [HDR]_Emission ("Emission", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Radius("Raio do gradiente", Range(0, 1.0)) = 0.5
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
        float _Radius;

        //Como faço pra aplicar esse shader em um ponto específico de um objeto?
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 uv = tex2D(_MainTex, IN.uv_MainTex);
            float2 center = IN.uv_MainTex - 1;

            float centerDist = saturate(length(center) / _Radius);
            o.Albedo = uv * _Color;
            o.Alpha = uv * (1-centerDist);
            o.Emission = uv * _Emission;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

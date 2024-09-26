Shader "Custom/Smoke"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex("Noise", 2D) = "white" {}
        _Slider("Fade", Range(0, 1.0)) = 1
        _Speed("Scroll Speed", Range(0, 1)) = 0.5
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend

        sampler2D _MainTex, _NoiseTex;
        float _Slider;
        float _Speed;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color, _Emission;

        //Queria que o offset em Y da textura mude constantemente
        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float time = _Time.y * _Speed;
            float2 uv = IN.uv_MainTex;
            uv.y -= time;
            float4 a = tex2D(_MainTex, uv);
            float3 noise = tex2D(_NoiseTex, uv);
            float k1 = step(noise, _Slider);

            o.Albedo = k1 * a * _Color;
            o.Alpha = k1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}


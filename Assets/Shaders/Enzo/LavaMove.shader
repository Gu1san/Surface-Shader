Shader "Custom/LavaMove"
{
    Properties
    {
       [HDR]_Color1("Color1",Color) = (1,1,1,1)
        [HDR]_Color2("Color2",Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex ("Normal", 2D) = "white" {}
        _Slider01 ("Slider A", Range(-0.2, 1)) = 0
        _Slider02 ("Slider B", Range(-0.2, 1)) = 0
        _Velocity ("Velocity", Range(0,1)) = 0.0
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend
        sampler2D _MainTex,_NormalTex;
        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;

        };
        fixed4 _Color1,_Color2;
        float _Slider01,_Slider02,_Velocity;
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = (tex2D (_MainTex, IN.uv_MainTex) * _Color1);
            fixed d = dot(IN.viewDir, o.Normal);
            float time = float2(_Time.y, _Time.y) * _Velocity;
            float3 n = tex2D(_NormalTex, IN.uv_MainTex + time);
            float k1 = step(n, _Slider01);
            float k2 = step(n, _Slider01 + _Slider02);
            o.Albedo =  saturate(k1 * c);
            o.Emission =  round(d) * ((k1) * _Color2) ;
            o.Alpha =  k2;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

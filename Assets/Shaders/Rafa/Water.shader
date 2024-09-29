Shader "Custom/Water" {
    Properties {
        _MainTex("Water Texture", 2D) = "white" {}
        _FoamTex("Foam Texture", 2D) = "white" {}
        _Tint("Colour Tint", Color) = (1,1,1,1)
        _Freq("Frequency", Range(0,5)) = 3
        _Speed("Speed", Range(0,100)) = 10
        _Amp("Amplitude", Range(0,1)) = 0.5
        _ScrollX("Scroll X", Range(-5,5)) = 1
        _ScrollY("Scroll Y", Range(-5,5)) = 1
    }
    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert 

        struct Input {
            float2 uv_MainTex;
            float3 vertColor;
        };

        float4 _Tint;
        float _Freq;
        float _Speed;
        float _Amp;
        sampler2D _MainTex;
        sampler2D _FoamTex;
        float _ScrollX;
        float _ScrollY;

        //Registros de vertex/normal/coordenadas
        struct appdata {
            float4 vertex: POSITION; 
            float3 normal: NORMAL;
            float4 texcoord: TEXCOORD0;
            float4 texcoord1: TEXCOORD1;
            float4 texcoord2: TEXCOORD2;
        };

        void vert (inout appdata v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            float t = _Time * _Speed;  // Tempo animado multiplicado pela velocidade
             // Cálculo da altura das ondas usando funções seno
            float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp +
                               sin(t * 2 + v.vertex.x * _Freq * 2) * _Amp;
            v.vertex.y += waveHeight; // Ajusta a posição Y do vértice com a altura da onda
             // Normaliza a normal do vértice, considerando a altura da onda
            v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
            o.vertColor = waveHeight + 2;  // Armazena a altura da onda
        }

        void surf (Input IN, inout SurfaceOutput o) {
            // Cálculo do deslocamento da espuma
            float scrollX = _ScrollX * _Time;
            float scrollY = _ScrollY * _Time;

            // Obtém a cor da espuma usando a textura e as coordenadas ajustadas
            float3 water = tex2D(_MainTex, IN.uv_MainTex + float2(scrollX, scrollY)).rgb;
            float3 foam = tex2D(_FoamTex, IN.uv_MainTex + float2(scrollX / 2.0, scrollY / 2.0)).rgb;

            // Combine colors
            o.Albedo = (water + foam) / 2.0 * IN.vertColor.rgb;
            o.Albedo *= _Tint.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

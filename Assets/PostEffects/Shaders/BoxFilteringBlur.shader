Shader "Hidden/BoxFilteringBlur"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            uniform float _Delta;

            float3 Sampling(float2 uv)
            {
                return tex2D(_MainTex, uv).rgb;
            }

            float4 BoxFilteringBlur(float2 uv, float delta)
            {
                float4 offset = _MainTex_TexelSize.xyxy * float2(-delta, delta).xxyy;

                // Sampling from diagonal four points.
                float3 col = Sampling(uv + offset.xy) // Bottom Left
                    + Sampling(uv + offset.zy)    // Bottom Right
                    + Sampling(uv + offset.xw)    // Top Left
                    + Sampling(uv + offset.zw);   // Top Right

                return float4(col.rgb * 0.25, tex2D(_MainTex, uv).a);
            }

            float4 frag(v2f_img i) : SV_Target
            {
                return BoxFilteringBlur(i.uv, _Delta);
            }
            ENDCG
        }
    }
}

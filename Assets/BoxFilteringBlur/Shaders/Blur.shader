Shader "Hidden/Blur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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

			float4 frag (v2f_img i) : SV_Target
			{
                float4 offset = _MainTex_TexelSize.xyxy * float2(-_Delta, _Delta).xxyy;

                // Sampling from diagonal four points.
                float3 col = Sampling(i.uv + offset.xy) // Bottom Left
                    + Sampling(i.uv + offset.zy)    // Bottom Right
                    + Sampling(i.uv + offset.xw)    // Top Left
                    + Sampling(i.uv + offset.zw);   // Top Right
                
                return float4(col.rgb * 0.25, tex2D(_MainTex, i.uv).a);
			}
			ENDCG
		}
	}
}

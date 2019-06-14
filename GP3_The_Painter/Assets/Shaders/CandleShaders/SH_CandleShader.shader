// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Attila_Herczeg/CandleShader"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_CoreColor("Core Color", Color) = (0.7075472,0.5351439,0.04338735,0)
		_OuterColor("Outer Color", Color) = (0.7058824,0.1114582,0.04313724,0)
		_BaseColor("Base Color", Color) = (0.06274474,0.3067562,0.8867924,0)
		_BrightnessMultiplier("Brightness Multiplier", Float) = 1.41
		_Noise("Noise", 2D) = "white" {}
		_NoiseScale("Noise Scale", Float) = 0.1
		_FlameFlickerSpeed("Flame Flicker Speed", Float) = 0.28
		_FakeGlow("Fake Glow", Range( 0 , 10)) = 0.3
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _BrightnessMultiplier;
		uniform float4 _CoreColor;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _Noise;
		uniform float _FlameFlickerSpeed;
		uniform float _NoiseScale;
		uniform float4 _Noise_ST;
		uniform float4 _OuterColor;
		uniform float4 _BaseColor;
		uniform float _FakeGlow;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult19 = (float2(-_FlameFlickerSpeed , -_FlameFlickerSpeed));
			float3 ase_worldPos = i.worldPos;
			float4 appendResult28 = (float4(ase_worldPos.x , ase_worldPos.y , 0.0 , 0.0));
			float2 uv0_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float2 panner14 = ( 1.0 * _Time.y * appendResult19 + ( ( appendResult28 * 0.1 ) + float4( ( _NoiseScale * uv0_Noise ), 0.0 , 0.0 ) ).xy);
			float4 tex2DNode1 = tex2D( _TextureSample0, ( ( ( (tex2D( _Noise, panner14 )).rg - float2( 0.5,0.5 ) ) * i.uv_texcoord.x ) + i.uv_texcoord ) );
			o.Emission = ( _BrightnessMultiplier * ( ( _CoreColor * tex2DNode1.r ) + ( _OuterColor * tex2DNode1.g ) + ( _BaseColor * tex2DNode1.b ) + ( tex2DNode1.a * _FakeGlow * _OuterColor ) ) ).rgb;
			o.Alpha = tex2DNode1.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows noshadow 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16702
1921;1;1678;986;726.5675;264.4467;1.432275;True;True
Node;AmplifyShaderEditor.CommentaryNode;31;-2249.828,-526.9664;Float;False;764.5571;352.6144;World Space Variation;4;27;28;30;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-2199.828,-476.9669;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;16;-2143.034,7.727141;Float;False;Property;_NoiseScale;Noise Scale;7;0;Create;True;0;0;False;0;0.1;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-2157.035,-137.2729;Float;False;0;13;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-1921.271,-289.3525;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1970.271,-468.3525;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2122.167,240.4198;Float;False;Property;_FlameFlickerSpeed;Flame Flicker Speed;8;0;Create;True;0;0;False;0;0.28;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1889.034,-61.27287;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;20;-1876.003,237.6433;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1654.271,-443.3525;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1574.2,-94.81779;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-1690.403,221.6433;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;14;-1502.214,102.3746;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;13;-1251.214,53.37462;Float;True;Property;_Noise;Noise;6;0;Create;True;0;0;False;0;ea9958ac605aa3d409e787190cfb5767;ea9958ac605aa3d409e787190cfb5767;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;24;-956.4216,59.85542;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-739.3666,46.34892;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1088.461,370.779;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-697.4801,174.3453;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-534.1812,144.6908;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-368.122,28.99486;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;e883cc671c4940b439bf1a9af74c3ca0;c2deb4ca1b95e4f48afdaf90821fae82;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-37.43231,-300.2295;Float;False;Property;_CoreColor;Core Color;1;0;Create;True;0;0;False;0;0.7075472,0.5351439,0.04338735,0;0.9816769,1,0.7216981,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-29.355,337.4716;Float;False;Property;_BaseColor;Base Color;4;0;Create;True;0;0;False;0;0.06274474,0.3067562,0.8867924,0;0,0.3038754,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-197.0658,681.862;Float;False;Property;_FakeGlow;Fake Glow;9;0;Create;True;0;0;False;0;0.3;0.89;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;9;-48.43237,-24.22946;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-4.93231,-65.72943;Float;False;Property;_OuterColor;Outer Color;3;0;Create;True;0;0;False;0;0.7058824,0.1114582,0.04313724,0;1,0.5783655,0.1273585,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;8;274.5676,283.7705;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;110.6356,669.862;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;284.0677,388.2706;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;274.0677,129.2706;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;292.5677,-186.2295;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;547.5599,-48.73611;Float;False;Property;_BrightnessMultiplier;Brightness Multiplier;5;0;Create;True;0;0;False;0;1.41;0.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;464.5838,60.4938;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;752.6385,35.56879;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;967.7375,-50.49249;Float;False;True;7;Float;ASEMaterialInspector;0;0;Unlit;Attila_Herczeg/CandleShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0;True;True;0;False;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;8;5;False;-1;1;False;-1;0;1;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;True;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;27;1
WireConnection;28;1;27;2
WireConnection;17;0;16;0
WireConnection;17;1;15;0
WireConnection;20;0;21;0
WireConnection;29;0;28;0
WireConnection;29;1;30;0
WireConnection;32;0;29;0
WireConnection;32;1;17;0
WireConnection;19;0;20;0
WireConnection;19;1;20;0
WireConnection;14;0;32;0
WireConnection;14;2;19;0
WireConnection;13;1;14;0
WireConnection;24;0;13;0
WireConnection;25;0;24;0
WireConnection;26;0;25;0
WireConnection;26;1;23;1
WireConnection;22;0;26;0
WireConnection;22;1;23;0
WireConnection;1;1;22;0
WireConnection;9;0;1;1
WireConnection;8;0;1;3
WireConnection;33;0;1;4
WireConnection;33;1;34;0
WireConnection;33;2;5;0
WireConnection;6;0;7;0
WireConnection;6;1;8;0
WireConnection;4;0;5;0
WireConnection;4;1;1;2
WireConnection;2;0;3;0
WireConnection;2;1;9;0
WireConnection;10;0;2;0
WireConnection;10;1;4;0
WireConnection;10;2;6;0
WireConnection;10;3;33;0
WireConnection;11;0;12;0
WireConnection;11;1;10;0
WireConnection;0;2;11;0
WireConnection;0;9;1;0
ASEEND*/
//CHKSM=94E761DF3DA9AED9237D253609E5B49D709BE172
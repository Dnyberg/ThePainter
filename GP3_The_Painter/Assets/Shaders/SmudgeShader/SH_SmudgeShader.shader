// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Attila_Herczeg/SmudgeShader"
{
	Properties
	{
		_FormTexture("Form Texture", 2D) = "white" {}
		_FromTexture2("From Texture 2", 2D) = "white" {}
		_NoiseTexture("Noise Texture", 2D) = "white" {}
		_Smudgecolor("Smudge color", Color) = (0.1509434,0.1509434,0.1509434,0)
		_Scale("Scale", Float) = 1.55
		_BlendStr("Blend Str", Float) = -5
		_UVScale("UV Scale", Float) = 1
		_Specular("Specular", Range( 0 , 1)) = 0.1
		_Smothness("Smothness", Range( 0 , 1)) = 0.55
		_NormalStr("Normal Str", Range( 0 , 5)) = 1
		_OpacityIntensity("Opacity Intensity", Range( 0 , 5)) = 0.65
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _FromTexture2;
		uniform float4 _FromTexture2_ST;
		uniform float _NormalStr;
		uniform float4 _Smudgecolor;
		uniform sampler2D _NoiseTexture;
		uniform float _UVScale;
		uniform sampler2D _FormTexture;
		uniform float4 _FormTexture_ST;
		uniform float _Scale;
		uniform float _BlendStr;
		uniform float _Specular;
		uniform float _Smothness;
		uniform float _OpacityIntensity;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv0_FromTexture2 = i.uv_texcoord * _FromTexture2_ST.xy + _FromTexture2_ST.zw;
			float2 temp_output_2_0_g2 = uv0_FromTexture2;
			float2 break6_g2 = temp_output_2_0_g2;
			float temp_output_25_0_g2 = ( pow( 0.5 , 3.0 ) * 0.1 );
			float2 appendResult8_g2 = (float2(( break6_g2.x + temp_output_25_0_g2 ) , break6_g2.y));
			float4 tex2DNode14_g2 = tex2D( _FromTexture2, temp_output_2_0_g2 );
			float temp_output_4_0_g2 = _NormalStr;
			float3 appendResult13_g2 = (float3(1.0 , 0.0 , ( ( tex2D( _FromTexture2, appendResult8_g2 ).g - tex2DNode14_g2.g ) * temp_output_4_0_g2 )));
			float2 appendResult9_g2 = (float2(break6_g2.x , ( break6_g2.y + temp_output_25_0_g2 )));
			float3 appendResult16_g2 = (float3(0.0 , 1.0 , ( ( tex2D( _FromTexture2, appendResult9_g2 ).g - tex2DNode14_g2.g ) * temp_output_4_0_g2 )));
			float3 normalizeResult22_g2 = normalize( cross( appendResult13_g2 , appendResult16_g2 ) );
			o.Normal = normalizeResult22_g2;
			float4 tex2DNode6 = tex2D( _NoiseTexture, ( i.uv_texcoord * _UVScale ) );
			float2 uv_FormTexture = i.uv_texcoord * _FormTexture_ST.xy + _FormTexture_ST.zw;
			float HeightMask1 = saturate(pow(((tex2DNode6.r*( ( tex2D( _FormTexture, uv_FormTexture ) * _Scale ) - tex2DNode6 ).r)*4)+(( ( tex2D( _FormTexture, uv_FormTexture ) * _Scale ) - tex2DNode6 ).r*2),_BlendStr));
			o.Emission = ( _Smudgecolor + HeightMask1 ).rgb;
			float temp_output_15_0 = ( 1.0 - HeightMask1 );
			float3 temp_cast_3 = (( _Specular * temp_output_15_0 )).xxx;
			o.Specular = temp_cast_3;
			o.Smoothness = ( temp_output_15_0 * _Smothness );
			o.Alpha = ( temp_output_15_0 * _OpacityIntensity );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
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
1927;1;1666;980;2725.163;1734.817;3.90095;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-2222.857,395.8495;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-2201.857,659.8495;Float;False;Property;_UVScale;UV Scale;6;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1461.257,140.8508;Float;False;Property;_Scale;Scale;4;0;Create;True;0;0;False;0;1.55;1.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1916.857,500.8495;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-1572.866,-83.23694;Float;True;Property;_FormTexture;Form Texture;0;0;Create;True;0;0;False;0;93040fc3ac65cf64ca830ffa2c73460e;1a577925f1abe3f42972616178f515f7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1239.257,-5.1492;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-1547.198,468.9163;Float;True;Property;_NoiseTexture;Noise Texture;2;0;Create;True;0;0;False;0;566130b4c7fa0164b8d8431b5e191a02;c9941e688984bc240b317e8a8a6b7077;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;-967.2568,2.8508;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-920.8569,209.8495;Float;False;Property;_BlendStr;Blend Str;5;0;Create;True;0;0;False;0;-5;-5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;1;-685.8665,50.76306;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1090.407,-217.4331;Float;False;Property;_NormalStr;Normal Str;9;0;Create;True;0;0;False;0;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;99.78217,477.7865;Float;False;Property;_OpacityIntensity;Opacity Intensity;12;0;Create;True;0;0;False;0;0.65;0.95;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-364.8239,254.1012;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-97.02197,325.9152;Float;False;Property;_Smothness;Smothness;8;0;Create;True;0;0;False;0;0.55;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-283.4807,-608.6633;Float;False;Property;_Smudgecolor;Smudge color;3;0;Create;True;0;0;False;0;0.1509434,0.1509434,0.1509434,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;44;-77.2301,-67.54071;Float;False;Property;_Specular;Specular;7;0;Create;True;0;0;False;0;0.1;0.208;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;52;-1111.545,-459.5636;Float;True;Property;_FromTexture2;From Texture 2;1;0;Create;True;0;0;False;0;93040fc3ac65cf64ca830ffa2c73460e;1a577925f1abe3f42972616178f515f7;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;203.978,232.9152;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;440.1315,309.6514;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;85.7699,-15.54071;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;54;-735.3279,-426.7337;Float;True;NormalCreate;10;;2;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;53;-1274.959,-731.7673;Float;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;False;0;566130b4c7fa0164b8d8431b5e191a02;566130b4c7fa0164b8d8431b5e191a02;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;58;266.5954,-506.7101;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;730.57,-295.5674;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;Attila_Herczeg/SmudgeShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;12;1;13;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;6;1;12;0
WireConnection;5;0;3;0
WireConnection;5;1;6;0
WireConnection;1;0;6;0
WireConnection;1;1;5;0
WireConnection;1;2;10;0
WireConnection;15;0;1;0
WireConnection;46;0;15;0
WireConnection;46;1;47;0
WireConnection;56;0;15;0
WireConnection;56;1;55;0
WireConnection;45;0;44;0
WireConnection;45;1;15;0
WireConnection;54;1;52;0
WireConnection;54;4;50;0
WireConnection;58;0;17;0
WireConnection;58;1;1;0
WireConnection;0;1;54;0
WireConnection;0;2;58;0
WireConnection;0;3;45;0
WireConnection;0;4;46;0
WireConnection;0;9;56;0
ASEEND*/
//CHKSM=B8DB02F376049AB1478EC60E1B7DD361D8268CCD
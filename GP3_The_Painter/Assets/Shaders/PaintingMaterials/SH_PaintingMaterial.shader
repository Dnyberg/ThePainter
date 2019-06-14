// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Attila_Herczeg/SH_PaintingMaterial"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_AlbedoUV("Albedo UV", Vector) = (1,1,0,0)
		_DetailTexture("Detail Texture", 2D) = "white" {}
		_DetailUV("Detail UV", Vector) = (1,1,0,0)
		_LightColorIntensity("Light Color Intensity", Float) = 0.1
		_ColorIntensity("Color Intensity", Float) = 0.5
		_LightColor("Light Color", Color) = (1,0.009791803,0,0)
		_DetailIntensity("Detail Intensity", Float) = 1
		_AlbedoIntensity("Albedo Intensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _DetailTexture;
		uniform float2 _DetailUV;
		uniform float _DetailIntensity;
		uniform sampler2D _Albedo;
		uniform float2 _AlbedoUV;
		uniform float _AlbedoIntensity;
		uniform float _ColorIntensity;
		uniform float4 _LightColor;
		uniform float _LightColorIntensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord66 = i.uv_texcoord * _DetailUV;
			float2 uv_TexCoord78 = i.uv_texcoord * _AlbedoUV;
			float4 temp_output_85_0 = ( tex2D( _Albedo, uv_TexCoord78 ) * _AlbedoIntensity );
			float4 lerpResult89 = lerp( ( tex2D( _DetailTexture, uv_TexCoord66 ) * _DetailIntensity ) , temp_output_85_0 , temp_output_85_0);
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float dotResult3 = dot( ase_worldlightDir , ase_worldNormal );
			o.Emission = ( ( lerpResult89 * _ColorIntensity ) + ( dotResult3 * ( _LightColor * _LightColorIntensity ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows exclude_path:deferred 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
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
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
1921;1;1678;986;1557.438;21.76897;1;True;False
Node;AmplifyShaderEditor.Vector2Node;77;-2349.18,-584.344;Float;False;Property;_AlbedoUV;Albedo UV;1;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;76;-1900.128,-2067.986;Float;False;Property;_DetailUV;Detail UV;3;0;Create;True;0;0;False;0;1,1;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;78;-2154.18,-607.344;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-1668.218,-2085.525;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;-1557.181,-356.0516;Float;False;Property;_AlbedoIntensity;Albedo Intensity;14;0;Create;True;0;0;False;0;0;1.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-1181.7,-1773.195;Float;False;Property;_DetailIntensity;Detail Intensity;13;0;Create;True;0;0;False;0;1;2.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;68;-1396.48,-2085.254;Float;True;Property;_DetailTexture;Detail Texture;2;0;Create;True;0;0;False;0;335a32816cb3e2a4889d5bdb1dbe5e77;335a32816cb3e2a4889d5bdb1dbe5e77;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;-1835.606,-568.5345;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;27182ec3b3c042f44882882b87631abe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;4;-1313.834,390.8147;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;1;-1313.834,181.8146;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-939.5527,-1888.362;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1298.479,-584.8513;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;-63.26405,795.0483;Float;False;Property;_LightColor;Light Color;11;0;Create;True;0;0;False;0;1,0.009791803,0,0;1,0.6994326,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-25.03198,1059.368;Float;False;Property;_LightColorIntensity;Light Color Intensity;5;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;164.5944,885.2654;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;89;-595.7623,-1368.85;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-1035.834,297.8146;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-190.6317,-728.1957;Float;False;Property;_ColorIntensity;Color Intensity;8;0;Create;True;0;0;False;0;0.5;1.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;6.48842,-851.4442;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-404.5583,204.1213;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;116;-678.4385,203.231;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-2106.746,-1851.009;Float;False;Property;_NoiseIntensity;Noise Intensity;10;0;Create;True;0;0;False;0;0;1.01;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;-1362.252,-1295.496;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;59;-2585.768,-1705.694;Float;True;Property;_NoiseTexture;Noise Texture;4;0;Create;True;0;0;False;0;e5a47db7dba3f4e48a71c138fef6e225;c9941e688984bc240b317e8a8a6b7077;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1709.669,-1794.216;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;129.3002,-201.1948;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-2850.506,-1720.665;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;63;-1718.983,-1286.987;Float;False;Property;_BaseColor;Base Color;7;0;Create;True;0;0;False;0;0.6431373,0.4993102,0.1647059,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;64;-1724.894,-1046.804;Float;False;Property;_NoiseColor;Noise Color;9;0;Create;True;0;0;False;0;0.4339623,0.2893232,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1188.141,964.035;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1437.408,1043.135;Float;False;Property;_LightIntensity;Light Intensity;12;0;Create;True;0;0;False;0;10;1.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;6;-1446.52,943.3977;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-840.7935,970.2986;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;90;-1019.619,-1152.284;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;75;-3161.51,-1719.015;Float;False;Property;_NoiseUV;Noise UV;6;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;60;-2102.364,-1705.44;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;786.1767,-157.2246;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Attila_Herczeg/SH_PaintingMaterial;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;78;0;77;0
WireConnection;66;0;76;0
WireConnection;68;1;66;0
WireConnection;65;1;78;0
WireConnection;79;0;68;0
WireConnection;79;1;80;0
WireConnection;85;0;65;0
WireConnection;85;1;86;0
WireConnection;53;0;23;0
WireConnection;53;1;54;0
WireConnection;89;0;79;0
WireConnection;89;1;85;0
WireConnection;89;2;85;0
WireConnection;3;0;1;0
WireConnection;3;1;4;0
WireConnection;72;0;89;0
WireConnection;72;1;70;0
WireConnection;52;0;3;0
WireConnection;52;1;53;0
WireConnection;116;0;3;0
WireConnection;67;0;62;0
WireConnection;67;1;63;0
WireConnection;67;2;62;0
WireConnection;59;1;57;0
WireConnection;62;0;61;0
WireConnection;62;1;60;0
WireConnection;107;0;72;0
WireConnection;107;1;52;0
WireConnection;57;0;75;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;5;0;3;0
WireConnection;5;1;7;0
WireConnection;90;0;67;0
WireConnection;90;1;85;0
WireConnection;90;2;85;0
WireConnection;60;0;59;0
WireConnection;0;2;107;0
ASEEND*/
//CHKSM=356D75F0D7A6CF42617AD13C30E4423979A770C5
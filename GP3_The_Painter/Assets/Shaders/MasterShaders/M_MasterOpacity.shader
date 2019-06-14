// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Attila_Herczeg/MasterOpacity"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_UVTiling("UV Tiling", Vector) = (1,1,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		_AlbedoMultiply("Albedo Multiply", Range( 0 , 2)) = 1
		_AlbedoTint("Albedo Tint", Color) = (0.6792453,0.6779718,0.3812745,0)
		_AlbedoTintAmount("Albedo Tint Amount", Range( 0 , 1)) = 0
		_Normal("Normal", 2D) = "white" {}
		_NormalStrength("Normal Strength", Range( 0 , 5)) = 1
		[Toggle(_DETAILMAP_ON)] _DetailMap("Detail Map", Float) = 0
		_DetailNormal("Detail Normal", 2D) = "bump" {}
		_DetailUVTiling("Detail UV Tiling", Range( 1 , 20)) = 1
		_DetailNormalSterngth("Detail Normal Sterngth", Range( 0 , 5)) = 1
		_Reflection("Reflection", 2D) = "white" {}
		_SmoothnessStrenght("Smoothness Strenght", Range( 0 , 1)) = 1
		_Metallic("Metallic ", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature _DETAILMAP_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float2 _UVTiling;
		uniform float _NormalStrength;
		uniform sampler2D _DetailNormal;
		uniform float _DetailUVTiling;
		uniform float _DetailNormalSterngth;
		uniform sampler2D _Albedo;
		uniform float _AlbedoMultiply;
		uniform float4 _AlbedoTint;
		uniform float _AlbedoTintAmount;
		uniform float _Metallic;
		uniform sampler2D _Reflection;
		uniform float _SmoothnessStrenght;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord8 = i.uv_texcoord * _UVTiling;
			float4 tex2DNode2 = tex2D( _Normal, uv_TexCoord8 );
			float4 appendResult43 = (float4(( tex2DNode2.r * _NormalStrength ) , ( tex2DNode2.g * _NormalStrength ) , 1.0 , 0.0));
			float2 temp_cast_1 = (_DetailUVTiling).xx;
			float2 uv_TexCoord60 = i.uv_texcoord * temp_cast_1;
			float3 tex2DNode58 = UnpackNormal( tex2D( _DetailNormal, uv_TexCoord60 ) );
			float3 appendResult65 = (float3(( tex2DNode58.r * _DetailNormalSterngth ) , ( _DetailNormalSterngth * tex2DNode58.g ) , 1.0));
			#ifdef _DETAILMAP_ON
				float4 staticSwitch57 = float4( BlendNormals( appendResult43.xyz , appendResult65 ) , 0.0 );
			#else
				float4 staticSwitch57 = appendResult43;
			#endif
			o.Normal = staticSwitch57.xyz;
			float4 tex2DNode1 = tex2D( _Albedo, uv_TexCoord8 );
			float3 temp_cast_5 = (tex2DNode1.r).xxx;
			float temp_output_9_0_g1 = tex2DNode1.r;
			float temp_output_18_0_g1 = ( 1.0 - temp_output_9_0_g1 );
			float3 appendResult16_g1 = (float3(temp_output_18_0_g1 , temp_output_18_0_g1 , temp_output_18_0_g1));
			float3 temp_output_18_0 = ( ( tex2DNode1.rgb * ( ( ( temp_cast_5 * (unity_ColorSpaceDouble).rgb ) * temp_output_9_0_g1 ) + appendResult16_g1 ) ) * _AlbedoMultiply );
			float4 blendOpSrc9 = float4( temp_output_18_0 , 0.0 );
			float4 blendOpDest9 = _AlbedoTint;
			float4 lerpResult14 = lerp( float4( temp_output_18_0 , 0.0 ) , ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest9) / blendOpSrc9) ) )) , _AlbedoTintAmount);
			o.Albedo = lerpResult14.rgb;
			float4 tex2DNode3 = tex2D( _Reflection, uv_TexCoord8 );
			o.Metallic = ( _Metallic * tex2DNode3.b );
			o.Smoothness = ( _SmoothnessStrenght * tex2DNode3.r );
			o.Occlusion = tex2DNode3.g;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16702
1921;24;1678;986;420.6758;-374.2041;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;67;-1741.557,1088.773;Float;False;1478.12;401.9087;Detail Normal;8;58;66;62;63;64;65;60;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;69;-2131.235,94.25775;Float;False;Property;_UVTiling;UV Tiling;1;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;59;-1691.557,1313.83;Float;False;Property;_DetailUVTiling;Detail UV Tiling;14;0;Create;True;0;0;False;0;1;1;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1858.471,71.5238;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-1406.21,1298.124;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-1374.877,407.0499;Float;False;Property;_NormalStrength;Normal Strength;11;0;Create;True;0;0;False;0;1;0.73;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1571.321,-308.6402;Float;True;Property;_Albedo;Albedo;6;0;Create;True;0;0;False;0;None;d107c8dd96ef7ae449a839d05c76192f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1399.388,201.6972;Float;True;Property;_Normal;Normal;10;0;Create;True;0;0;False;0;None;8db6c130e2dbb0f4f8187ae94c0d5f2a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;-1081.984,1138.773;Float;False;Property;_DetailNormalSterngth;Detail Normal Sterngth;15;0;Create;True;0;0;False;0;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;58;-1116.553,1255.39;Float;True;Property;_DetailNormal;Detail Normal;13;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;64;-715.3939,1375.682;Float;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-972.2643,460.4186;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;54;-1239.88,-343.4756;Float;False;Detail Albedo;2;;1;29e5a290b15a7884983e27c8f1afaa8c;0;3;12;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;9;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-967.9855,352.4187;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-731.6035,1143.76;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1416.266,-7.714279;Float;False;Property;_AlbedoMultiply;Albedo Multiply;7;0;Create;True;0;0;False;0;1;0.289;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-730.3565,1254.733;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-970.876,247.3934;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;-498.4371,1166.205;Float;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-978.9836,-222.2612;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-769.3229,281.5326;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;11;-1046.765,25.28571;Float;False;Property;_AlbedoTint;Albedo Tint;8;0;Create;True;0;0;False;0;0.6792453,0.6779718,0.3812745,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-1034.878,929.8669;Float;False;Property;_Metallic;Metallic ;19;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;9;-727.7654,-42.71429;Float;True;ColorBurn;True;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-482.9653,66.28561;Float;False;Property;_AlbedoTintAmount;Albedo Tint Amount;9;0;Create;True;0;0;False;0;0;0.693;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;56;-337.208,587.4061;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1070.539,557.6584;Float;False;Property;_SmoothnessStrenght;Smoothness Strenght;17;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1403.922,684.0837;Float;True;Property;_Reflection;Reflection;16;0;Create;True;0;0;False;0;None;b4e31324f65e09e439b40ba0e84c051c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-696.9514,731.998;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;57;-254.8956,309.8274;Float;False;Property;_DetailMap;Detail Map;12;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-699.3328,578.2064;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;14;-375.4318,-191.3876;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1118.144,660.1541;Float;False;Property;_AoStrength;Ao Strength;18;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-695.0555,865.1381;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;397.38,362.1014;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Attila_Herczeg/MasterOpacity;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;69;0
WireConnection;60;0;59;0
WireConnection;1;1;8;0
WireConnection;2;1;8;0
WireConnection;58;1;60;0
WireConnection;54;12;1;0
WireConnection;54;11;1;1
WireConnection;54;9;1;1
WireConnection;41;0;2;2
WireConnection;41;1;22;0
WireConnection;62;0;58;1
WireConnection;62;1;66;0
WireConnection;63;0;66;0
WireConnection;63;1;58;2
WireConnection;40;0;2;1
WireConnection;40;1;22;0
WireConnection;65;0;62;0
WireConnection;65;1;63;0
WireConnection;65;2;64;0
WireConnection;18;0;54;0
WireConnection;18;1;13;0
WireConnection;43;0;40;0
WireConnection;43;1;41;0
WireConnection;43;2;44;0
WireConnection;9;0;18;0
WireConnection;9;1;11;0
WireConnection;56;0;43;0
WireConnection;56;1;65;0
WireConnection;3;1;8;0
WireConnection;68;0;50;0
WireConnection;68;1;3;2
WireConnection;57;1;43;0
WireConnection;57;0;56;0
WireConnection;47;0;46;0
WireConnection;47;1;3;1
WireConnection;14;0;18;0
WireConnection;14;1;9;0
WireConnection;14;2;15;0
WireConnection;49;0;48;0
WireConnection;49;1;3;3
WireConnection;0;0;14;0
WireConnection;0;1;57;0
WireConnection;0;3;49;0
WireConnection;0;4;47;0
WireConnection;0;5;3;2
WireConnection;0;10;1;4
ASEEND*/
//CHKSM=A054EB3A4098E72E600AD7B4E106D090384ACE6F
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Attila_Herczeg/OilPaint"
{
	Properties
	{
		_RenderTexture("Render Texture", 2D) = "white" {}
		_PictureNormalIntensity("Picture Normal Intensity", Range( 0 , 100)) = 2
		_ReflectanceTexture("Reflectance Texture", 2D) = "white" {}
		_SmothnessIntensity("Smothness Intensity", Range( 0 , 2)) = 0
		_AoMultiply("Ao Multiply", Range( 0 , 2)) = 1
		[Normal]_PictureNormal("Picture Normal", 2D) = "bump" {}
		_UV("UV ", Float) = 2.5
		_Smothnesscontreast("Smothnesscontreast", Range( 0 , 10)) = 1
		_EmissiveStrength("EmissiveStrength", Float) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.5
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _PictureNormalIntensity;
		uniform sampler2D _PictureNormal;
		uniform float _UV;
		uniform sampler2D _RenderTexture;
		uniform float4 _RenderTexture_ST;
		uniform float _EmissiveStrength;
		uniform float _SmothnessIntensity;
		uniform float _Smothnesscontreast;
		uniform sampler2D _ReflectanceTexture;
		uniform float _AoMultiply;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_output_756_0 = ( _UV * i.uv_texcoord );
			float3 tex2DNode748 = UnpackScaleNormal( tex2D( _PictureNormal, temp_output_756_0 ), _PictureNormalIntensity );
			o.Normal = tex2DNode748;
			float2 uv_RenderTexture = i.uv_texcoord * _RenderTexture_ST.xy + _RenderTexture_ST.zw;
			float4 tex2DNode465 = tex2D( _RenderTexture, uv_RenderTexture );
			o.Albedo = tex2DNode465.rgb;
			o.Emission = ( tex2DNode465 * _EmissiveStrength ).rgb;
			float4 tex2DNode387 = tex2D( _ReflectanceTexture, temp_output_756_0 );
			float clampResult764 = clamp( ( _Smothnesscontreast * tex2DNode387.r ) , 0.0 , 1.0 );
			float temp_output_389_0 = ( _SmothnessIntensity * clampResult764 );
			o.Smoothness = temp_output_389_0;
			o.Occlusion = ( 1.0 - ( _AoMultiply * ( 1.0 - tex2DNode387.g ) ) );
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16702
1921;24;1678;986;2238.27;-228.7818;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;758;-2690.425,630.5723;Float;False;Property;_UV;UV ;15;0;Create;True;0;0;False;0;2.5;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;755;-2740.539,897.5492;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;756;-2466.236,853.061;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;761;-2115.889,656.4639;Float;False;Property;_Smothnesscontreast;Smothnesscontreast;17;0;Create;True;0;0;False;0;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;387;-2182.917,830.9578;Float;True;Property;_ReflectanceTexture;Reflectance Texture;7;0;Create;True;0;0;False;0;e5a47db7dba3f4e48a71c138fef6e225;5a9406f3b6587b3488a15a023081d59e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;751;-1724.479,1092.202;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;762;-1835.027,724.634;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;749;-1706.635,851.9187;Float;False;Property;_AoMultiply;Ao Multiply;9;0;Create;True;0;0;False;0;1;0.1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;766;-1746.417,454.0817;Float;False;Property;_EmissiveStrength;EmissiveStrength;18;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;370;-1823.9,576.1899;Float;False;Property;_SmothnessIntensity;Smothness Intensity;8;0;Create;True;0;0;False;0;0;0.987;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;764;-1668.692,687.8221;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;742;-2272.446,1391.525;Float;False;Property;_PictureNormalIntensity;Picture Normal Intensity;6;0;Create;True;0;0;False;0;2;0.4;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;750;-1496.143,988.5824;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;465;-1928.245,111.4899;Float;True;Property;_RenderTexture;Render Texture;0;0;Create;True;0;0;False;0;None;e050049c704d45f4282dada228d969e9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;753;-1303.607,766.0569;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;623;-4289.971,731.7998;Float;True;Property;_Depth;Depth;10;0;Create;True;0;0;False;0;None;d0c4d52c05ec49e48bc74846f544c545;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;285;-5362.726,-385.0062;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;293;-5078.302,-256.799;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;-5415.726,-69.00623;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;740;-3090.896,322.7347;Float;False;Property;_NoiseIntensity;Noise Intensity;3;0;Create;True;0;0;False;0;10;0.6;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;286;-5161.726,-509.0065;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-5545.726,-309.006;Float;False;Constant;_Float7;Float 7;10;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;277;-6042.373,151.8587;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;281;-5834.373,-824.1414;Float;True;Property;_TextureSample5;Texture Sample 5;14;0;Create;True;0;0;False;0;None;4b05bc0f7ff0dc846b450b358a6d129c;True;0;False;white;Auto;False;Instance;465;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;280;-5834.373,167.8587;Float;True;Property;_TextureSample4;Texture Sample 4;14;0;Create;True;0;0;False;0;None;4b05bc0f7ff0dc846b450b358a6d129c;True;0;False;white;Auto;False;Instance;465;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;752;-1346.479,1042.202;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;320;-3100.259,191.084;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;455;-3328.534,78.44043;Float;False;Constant;_Noisetiling;Noise  tiling;14;0;Create;True;0;0;False;0;50,50;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;322;-3375.384,235.8916;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;744;-1216.875,31.02863;Float;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;None;c175bcd634116a949b7726a20ba35d80;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;722;-2816.317,386.4725;Float;False;Property;_TilePositiveXY;Tile Positive XY;4;0;Create;True;0;0;False;0;0.01,0.01;0.002,0.002;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-5442.726,295.9935;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;389;-1456.255,585.6534;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;765;-1448.122,407.482;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;759;-1009.443,278.8935;Float;True;VividLight;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;279;-5834.373,-200.1413;Float;True;Property;_TextureSample2;Texture Sample 2;14;0;Create;True;0;0;False;0;None;4b05bc0f7ff0dc846b450b358a6d129c;True;0;False;white;Auto;False;Instance;465;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;271;-6191.546,184.3336;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-5628.726,420.9935;Float;False;Constant;_Float9;Float 9;10;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;274;-6042.373,-168.1413;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;736;-2282.161,349.0589;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;266;-6728.12,-247.9486;Float;False;Property;_BlurSize;Blur Size;11;0;Create;True;0;0;False;0;0;0.0028;0;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;754;-1578.769,1175.441;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;618;-2477.184,-9.10972;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;463;-6739.663,-448.9365;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;290;-5641.726,8.993563;Float;False;Constant;_Float8;Float 8;10;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;284;-5591.726,-649.0065;Float;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;273;-6042.373,-504.1413;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;748;-1863.742,1375.029;Float;True;Property;_PictureNormal;Picture Normal;13;1;[Normal];Create;True;0;0;False;0;None;7da9cf2fbc5abfc4d8b22afc51b2ca91;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;716;-2453.34,261.2041;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;278;-5834.373,-536.1414;Float;True;Property;_TextureSample0;Texture Sample 0;14;0;Create;True;0;0;False;0;None;4b05bc0f7ff0dc846b450b358a6d129c;True;0;False;white;Auto;False;Instance;465;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;269;-6197.529,-432.6961;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;-2138.786,205.3837;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;292;-4894.961,-65.52783;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;723;-2534.019,436.3727;Float;False;Property;_TileNegativXY;Tile Negativ XY;5;0;Create;True;0;0;False;0;-0.01,-0.01;-0.002,-0.002;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;745;-2863.201,-81.73279;Float;False;Property;_Offset;Offset;12;0;Create;True;0;0;False;0;0,0;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;760;-1213.628,348.162;Float;False;Property;_Float1;Float 1;16;0;Create;True;0;0;False;0;0.67;0.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;715;-2795.36,153.1553;Float;True;Property;_NoiseTexture;Noise Texture;2;0;Create;True;0;0;False;0;a82913ad79d69f64ea9c84b4dd98987d;7da9cf2fbc5abfc4d8b22afc51b2ca91;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;5;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;270;-6237.526,-122.5043;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;757;-2739.235,720.4613;Float;False;Property;_MasterTiling;Master Tiling;14;0;Create;True;0;0;False;0;1,1;2.5,2.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;283;-5372.726,-738.0067;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;747;-1303.941,917.9536;Float;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;92;-758.6249,634.8533;Float;False;True;3;Float;ASEMaterialInspector;0;0;Standard;Attila_Herczeg/OilPaint;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;756;0;758;0
WireConnection;756;1;755;0
WireConnection;387;1;756;0
WireConnection;751;0;387;2
WireConnection;762;0;761;0
WireConnection;762;1;387;1
WireConnection;764;0;762;0
WireConnection;750;0;749;0
WireConnection;750;1;751;0
WireConnection;753;0;389;0
WireConnection;285;0;278;0
WireConnection;285;1;287;0
WireConnection;293;0;286;0
WireConnection;293;1;288;0
WireConnection;288;0;279;0
WireConnection;288;1;290;0
WireConnection;286;0;283;0
WireConnection;286;1;285;0
WireConnection;277;0;463;0
WireConnection;277;1;271;0
WireConnection;281;1;463;0
WireConnection;280;1;277;0
WireConnection;752;0;750;0
WireConnection;320;0;455;0
WireConnection;320;1;322;0
WireConnection;289;0;280;0
WireConnection;289;1;291;0
WireConnection;389;0;370;0
WireConnection;389;1;764;0
WireConnection;765;0;465;0
WireConnection;765;1;766;0
WireConnection;759;0;465;0
WireConnection;759;1;760;0
WireConnection;279;1;274;0
WireConnection;271;0;266;0
WireConnection;271;1;266;0
WireConnection;274;0;463;0
WireConnection;274;1;270;0
WireConnection;736;0;716;0
WireConnection;736;1;723;0
WireConnection;754;0;742;0
WireConnection;754;1;748;0
WireConnection;618;1;745;0
WireConnection;273;0;463;0
WireConnection;273;1;269;0
WireConnection;748;1;756;0
WireConnection;748;5;742;0
WireConnection;716;0;715;0
WireConnection;716;1;722;0
WireConnection;278;1;273;0
WireConnection;269;1;266;0
WireConnection;141;0;618;0
WireConnection;141;1;736;0
WireConnection;292;0;293;0
WireConnection;292;1;289;0
WireConnection;715;1;320;0
WireConnection;270;0;266;0
WireConnection;283;0;281;0
WireConnection;283;1;284;0
WireConnection;92;0;465;0
WireConnection;92;1;748;0
WireConnection;92;2;765;0
WireConnection;92;4;389;0
WireConnection;92;5;752;0
ASEEND*/
//CHKSM=B2F1473231849D5DFDCE44CB9BFBE599DB8CE632
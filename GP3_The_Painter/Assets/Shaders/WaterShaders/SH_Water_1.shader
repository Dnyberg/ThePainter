// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Attila_Herczeg/SH_Water_1"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 17.4
		_LightColorIntensity("Light Color Intensity", Float) = 0.1
		_WaterFallof("Water Fallof", Float) = -3.6
		_WaterDepth("Water Depth", Float) = 0.99
		_ShalowColor("Shalow Color", Color) = (0.3158597,0.5931625,0.735849,0)
		_DeepColor("Deep Color", Color) = (0.08346715,0.07195622,0.3113208,0)
		_MovingWave("MovingWave", 2D) = "white" {}
		_WaterNormal("WaterNormal", 2D) = "bump" {}
		_LightColor("Light Color", Color) = (1,0.009791803,0,0)
		_NormalScale2("Normal Scale 2", Float) = 0
		_Distortion("Distortion", Float) = 0
		_FoamDepth("Foam Depth", Float) = 0
		_Foam("Foam", 2D) = "white" {}
		_FoamFallof("Foam Fallof", Float) = 0
		_FresnelColor("Fresnel Color", Color) = (0,0,0,0)
		_WaveSize("Wave Size", Float) = 0
		_WaveMovment2("Wave Movment 2", Vector) = (0.005,0.005,0,0)
		_WaveMovment1("Wave Movment 1", Vector) = (0.005,0.005,0,0)
		_WaveSpeed("Wave Speed", Float) = 0.77
		_FresnelScale("Fresnel Scale", Float) = 1
		_FresnelBias("Fresnel Bias", Float) = 0
		_FresnelPower("Fresnel Power", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ "_WaterGrab" }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float4 screenPos;
			half2 uv_texcoord;
		};

		uniform sampler2D _MovingWave;
		uniform half _WaveSpeed;
		uniform half _WaveSize;
		uniform half4 _LightColor;
		uniform half _LightColorIntensity;
		uniform half4 _DeepColor;
		uniform half4 _ShalowColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _WaterDepth;
		uniform half _WaterFallof;
		uniform half _FoamDepth;
		uniform half _FoamFallof;
		uniform sampler2D _Foam;
		uniform float4 _Foam_ST;
		uniform sampler2D _WaterGrab;
		uniform sampler2D _WaterNormal;
		uniform half _NormalScale2;
		uniform half2 _WaveMovment2;
		uniform float4 _WaterNormal_ST;
		uniform half2 _WaveMovment1;
		uniform half _Distortion;
		uniform half _FresnelBias;
		uniform half _FresnelScale;
		uniform half _FresnelPower;
		uniform half4 _FresnelColor;
		uniform half _EdgeLength;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_vertex3Pos = v.vertex.xyz;
			half2 temp_cast_0 = (( ( ase_vertex3Pos.y + _Time.x ) / _WaveSpeed )).xx;
			float2 uv_TexCoord161 = v.texcoord.xy * float2( 2,2 ) + temp_cast_0;
			v.vertex.xyz += ( ase_vertexNormal.y * ( tex2Dlod( _MovingWave, half4( uv_TexCoord161, 0, 0.0) ) * _WaveSize ) ).rgb;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			half3 ase_worldNormal = i.worldNormal;
			float dotResult210 = dot( ase_worldlightDir , ase_worldNormal );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float eyeDepth15 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos )));
			float temp_output_13_0 = abs( ( eyeDepth15 - ase_screenPos.w ) );
			float temp_output_8_0 = saturate( pow( ( temp_output_13_0 + _WaterDepth ) , _WaterFallof ) );
			float4 lerpResult19 = lerp( _DeepColor , _ShalowColor , temp_output_8_0);
			float4 color40 = IsGammaSpace() ? half4(1,1,1,0) : half4(1,1,1,0);
			float2 uv0_Foam = i.uv_texcoord * _Foam_ST.xy + _Foam_ST.zw;
			float2 panner49 = ( 1.0 * _Time.y * float2( -0.01,0.01 ) + uv0_Foam);
			float temp_output_47_0 = ( saturate( pow( ( temp_output_13_0 + _FoamDepth ) , _FoamFallof ) ) * tex2D( _Foam, panner49 ).r );
			float4 lerpResult38 = lerp( lerpResult19 , color40 , temp_output_47_0);
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 uv0_WaterNormal = i.uv_texcoord * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
			float2 panner4 = ( 1.0 * _Time.y * _WaveMovment2 + uv0_WaterNormal);
			float2 panner3 = ( 1.0 * _Time.y * _WaveMovment1 + uv0_WaterNormal);
			float3 temp_output_23_0 = BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, panner4 ), _NormalScale2 ) , UnpackScaleNormal( tex2D( _WaterNormal, panner3 ), _NormalScale2 ) );
			float4 screenColor187 = tex2D( _WaterGrab, ( half3( (ase_grabScreenPosNorm).xy ,  0.0 ) + ( temp_output_23_0 * _Distortion ) ).xy );
			float fresnelNdotV90 = dot( ase_worldNormal, temp_output_23_0 );
			float fresnelNode90 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV90, _FresnelPower ) );
			float4 lerpResult199 = lerp( lerpResult38 , ( screenColor187 + ( fresnelNode90 * _FresnelColor ) ) , temp_output_8_0);
			o.Emission = ( ( dotResult210 * ( _LightColor * _LightColorIntensity ) ) + lerpResult199 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16702
1921;1;1678;986;-1238.495;534.5363;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;37;-2132.637,-36.23582;Float;False;949.0001;321;Screen depth difference to get intersection and fading effect with object;4;15;14;13;201;;1,0.25,0.3788104,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;201;-2075.617,78.07207;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;205;-1410.919,-814.2239;Float;False;Property;_WaveMovment2;Wave Movment 2;25;0;Create;True;0;0;False;0;0.005,0.005;-0.03,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;204;-1482.364,-528.0192;Float;False;Property;_WaveMovment1;Wave Movment 1;26;0;Create;True;0;0;False;0;0.005,0.005;0.05,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScreenDepthNode;15;-1800.637,13.76418;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1563.554,-672.408;Float;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;-997.855,-659.1705;Float;False;Property;_NormalScale2;Normal Scale 2;13;0;Create;True;0;0;False;0;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;4;-971.3215,-800.6074;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-1515.637,144.7642;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1;-1047.548,-227.361;Float;False;1040.004;656.2918;Depths contols and color;10;21;20;19;18;17;12;9;8;6;200;;0.4198113,0.5070273,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;3;-978.3215,-553.607;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-750.3218,-575.6069;Float;True;Property;_WaterNormal;WaterNormal;11;0;Create;True;0;0;False;0;None;ada4f524172ef8c4fa08cfbd231bb3dd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-1230.511,611.0585;Float;False;Property;_FoamDepth;Foam Depth;18;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-997.548,259.9306;Float;False;Property;_WaterDepth;Water Depth;7;0;Create;True;0;0;False;0;0.99;64.73;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;185;-736.2777,-801.0203;Float;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;0;0;False;0;None;774706082f2e2ac4386b00a516302ae7;True;0;True;bump;Auto;True;Instance;2;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;13;-1337.637,151.7642;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-1015.215,514.4241;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1001.511,685.0585;Float;False;Property;_FoamFallof;Foam Fallof;20;0;Create;True;0;0;False;0;0;2.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;167;425.8104,725.6877;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;169;419.6577,869.4003;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;23;-374.2384,-609.8321;Float;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-774.2592,336.9306;Float;False;Property;_WaterFallof;Water Fallof;6;0;Create;True;0;0;False;0;-3.6;-9.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-183.3861,-905.256;Float;False;Property;_Distortion;Distortion;14;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-799.5481,151.9308;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;197;-299.6478,-1162.439;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-1277.511,908.7586;Float;False;0;50;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-800.5443,-14.36026;Float;False;Property;_ShalowColor;Shalow Color;8;0;Create;True;0;0;False;0;0.3158597,0.5931625,0.735849,0;0,1,0.8588235,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;168;685.162,783.9335;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;668.2963,932.9541;Float;False;Property;_WaveSpeed;Wave Speed;27;0;Create;True;0;0;False;0;0.77;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-805.5443,-177.361;Float;False;Property;_DeepColor;Deep Color;9;0;Create;True;0;0;False;0;0.08346715,0.07195622,0.3113208,0;0,0.29,0.5,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;95;25.42395,-256.0364;Float;False;Property;_FresnelScale;Fresnel Scale;28;0;Create;True;0;0;False;0;1;0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;48.42395,-351.0364;Float;False;Property;_FresnelBias;Fresnel Bias;29;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;49;-955.5107,955.0586;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.01,0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;96;41.42395,-174.0364;Float;False;Property;_FresnelPower;Fresnel Power;30;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;44;-826.5107,551.0585;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;198;-27.64783,-1127.439;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;200;-576.266,194.5881;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-11.02439,-919.9708;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;93;281.0136,-743.767;Float;False;Property;_FresnelColor;Fresnel Color;23;0;Create;True;0;0;False;0;0,0,0,0;1,0.5167219,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;90;242.1381,-372.2745;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;8;-388.4125,230.222;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;12;-349.5444,-92.36047;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;170;887.4688,792.4337;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;-727.5107,1124.058;Float;True;Property;_Foam;Foam;19;0;Create;True;0;0;False;0;None;826f80ee0ad07444c8558af826a4df2e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;193;217.3522,-1029.439;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;18;-352.5444,73.63972;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;46;-619.5107,578.0585;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-255.5546,-10.41569;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;207;1344.034,-1273.776;Float;False;Property;_LightColor;Light Color;12;0;Create;True;0;0;False;0;1,0.009791803,0,0;1,0.009791803,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;634.6483,-603.5626;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-277.8217,786.7445;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;161;1103.691,701.8402;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;-189.5806,457.4097;Float;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;208;1382.266,-1009.457;Float;False;Property;_LightColorIntensity;Light Color Intensity;5;0;Create;True;0;0;False;0;0.1;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;209;989.9792,-1702.436;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenColorNode;187;508.1863,-1056.547;Float;False;Global;_WaterGrab;WaterGrab;23;0;Create;True;0;0;False;0;Object;-1;True;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;206;1015.537,-1462.755;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;210;1267.979,-1586.435;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;163;1514.692,578.605;Float;True;Property;_MovingWave;MovingWave;10;0;Create;True;0;0;False;0;None;b6b7ce044a0c5ef408f602ff61b3a415;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;159;1671.969,417.8267;Float;False;Property;_WaveSize;Wave Size;24;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;203;845.7038,-704.5001;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;1571.892,-1183.559;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;38;99.68914,409.4978;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;199;1395.864,-461.1011;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;1945.2,453.8232;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;156;1712.419,165.5429;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;1743.154,-1606.374;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;213;1966.214,-1005.573;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;216;1958.368,636.449;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;51;376.5293,83.33722;Float;False;Property;_FoamSpecular;Foam Specular;21;0;Create;True;0;0;False;0;0;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;57;516.9643,640.5427;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;765.43,328.9378;Float;False;Property;_FoamSmoothness;Foam Smoothness;22;0;Create;True;0;0;False;0;0;8.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;773.2281,249.2324;Float;False;Property;_WaterSmoothness;Water Smoothness;17;0;Create;True;0;0;False;0;0;0.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;374.3293,-14.96405;Float;False;Property;_WaterSpecular;Water Specular;15;0;Create;True;0;0;False;0;0;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;218;1777.151,859.5392;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;219;2487.386,546.2509;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;2157.125,284.9178;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;56;1019.515,368.1427;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;58;333.0513,632.6294;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;1147.72,-110.7094;Float;False;Property;_AO;AO;16;0;Create;True;0;0;False;0;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;576.1295,84.63721;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;217;2258.964,810.8652;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2438.669,-160.8512;Half;False;True;6;Half;ASEMaterialInspector;0;0;Unlit;Attila_Herczeg/SH_Water_1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;False;0;False;Opaque;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;17.4;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;201;0
WireConnection;4;0;7;0
WireConnection;4;2;205;0
WireConnection;14;0;15;0
WireConnection;14;1;201;4
WireConnection;3;0;7;0
WireConnection;3;2;204;0
WireConnection;2;1;3;0
WireConnection;2;5;59;0
WireConnection;185;1;4;0
WireConnection;185;5;59;0
WireConnection;13;0;14;0
WireConnection;41;0;13;0
WireConnection;41;1;42;0
WireConnection;23;0;185;0
WireConnection;23;1;2;0
WireConnection;20;0;13;0
WireConnection;20;1;21;0
WireConnection;168;0;167;2
WireConnection;168;1;169;1
WireConnection;49;0;48;0
WireConnection;44;0;41;0
WireConnection;44;1;45;0
WireConnection;198;0;197;0
WireConnection;200;0;20;0
WireConnection;200;1;9;0
WireConnection;29;0;23;0
WireConnection;29;1;30;0
WireConnection;90;4;23;0
WireConnection;90;1;94;0
WireConnection;90;2;95;0
WireConnection;90;3;96;0
WireConnection;8;0;200;0
WireConnection;12;0;6;0
WireConnection;170;0;168;0
WireConnection;170;1;171;0
WireConnection;50;1;49;0
WireConnection;193;0;198;0
WireConnection;193;1;29;0
WireConnection;18;0;17;0
WireConnection;46;0;44;0
WireConnection;19;0;12;0
WireConnection;19;1;18;0
WireConnection;19;2;8;0
WireConnection;120;0;90;0
WireConnection;120;1;93;0
WireConnection;47;0;46;0
WireConnection;47;1;50;1
WireConnection;161;1;170;0
WireConnection;187;0;193;0
WireConnection;210;0;209;0
WireConnection;210;1;206;0
WireConnection;163;1;161;0
WireConnection;203;0;187;0
WireConnection;203;1;120;0
WireConnection;211;0;207;0
WireConnection;211;1;208;0
WireConnection;38;0;19;0
WireConnection;38;1;40;0
WireConnection;38;2;47;0
WireConnection;199;0;38;0
WireConnection;199;1;203;0
WireConnection;199;2;8;0
WireConnection;158;0;163;0
WireConnection;158;1;159;0
WireConnection;212;0;210;0
WireConnection;212;1;211;0
WireConnection;213;0;212;0
WireConnection;213;1;199;0
WireConnection;57;0;47;0
WireConnection;219;0;216;0
WireConnection;157;0;156;2
WireConnection;157;1;158;0
WireConnection;56;0;54;0
WireConnection;56;1;52;0
WireConnection;56;2;57;0
WireConnection;58;0;47;0
WireConnection;55;0;53;0
WireConnection;55;1;51;0
WireConnection;55;2;58;0
WireConnection;217;0;216;0
WireConnection;0;2;213;0
WireConnection;0;11;157;0
ASEEND*/
//CHKSM=AD3476C6EA4A0917DA2B9753211FFB62B20EDD2E
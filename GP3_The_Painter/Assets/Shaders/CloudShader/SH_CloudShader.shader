// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Attila_Herczeg/SH_CloudShader"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_Noise1Scale("Noise 1 Scale", Float) = 0.53
		_CloudCutoff("Cloud Cutoff", Range( 0 , 1)) = 0.06764707
		_CloudSoftness("Cloud Softness", Range( 0.15 , 3)) = 0.01
		_CloudSpeed("Cloud Speed", Float) = 0
		_NoiseMasterScale("Noise Master Scale", Float) = 0
		_Noise2Scale("Noise 2 Scale", Float) = 0
		_midYValue("midYValue", Float) = 0
		_cloudHeight("cloudHeight", Float) = 0
		_TaperPower("Taper Power", Float) = 4.26
		_Colorstr("Color str", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
		};

		uniform half _Colorstr;
		uniform half _midYValue;
		uniform half _cloudHeight;
		uniform half _TaperPower;
		uniform sampler2D _Texture0;
		uniform half _Noise1Scale;
		uniform half _CloudSpeed;
		uniform half _NoiseMasterScale;
		uniform half _Noise2Scale;
		uniform half _CloudCutoff;
		uniform half _CloudSoftness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float temp_output_39_0 = ( 1.0 - pow( saturate( ( abs( ( _midYValue - ase_worldPos.y ) ) / ( _cloudHeight * 0.25 ) ) ) , _TaperPower ) );
			float2 appendResult9 = (half2(ase_worldPos.x , ase_worldPos.z));
			float mulTime6 = _Time.y * _CloudSpeed;
			float2 appendResult10 = (half2(mulTime6 , mulTime6));
			float temp_output_16_0 = ( tex2D( _Texture0, ( _Noise1Scale * ( appendResult9 - appendResult10 ) * _NoiseMasterScale ) ).r * tex2D( _Texture0, ( _Noise2Scale * ( appendResult9 + appendResult10 ) * _NoiseMasterScale ) ).r );
			half3 temp_cast_0 = (( _Colorstr * ( 1.0 - ( temp_output_39_0 - ( temp_output_39_0 * temp_output_16_0 ) ) ) )).xxx;
			o.Albedo = temp_cast_0;
			o.Alpha = pow( saturate( (0.0 + (temp_output_16_0 - _CloudCutoff) * (1.0 - 0.0) / (1.0 - _CloudCutoff)) ) , _CloudSoftness );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
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
				float3 worldPos : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
1888;5;1666;964;3225.38;1715.931;3.283568;True;False
Node;AmplifyShaderEditor.CommentaryNode;40;-1675.014,-742.1751;Float;False;1452;416.6016;Vertical Falloff;11;35;29;30;31;32;33;34;36;37;38;39;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;31;-1625.014,-575.5735;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-1603.979,-692.1751;Float;False;Property;_midYValue;midYValue;7;0;Create;True;0;0;False;0;0;16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2058.269,235.1681;Float;False;Property;_CloudSpeed;Cloud Speed;4;0;Create;True;0;0;False;0;0;0.74;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-1893.525,31.79792;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;35;-1395.014,-462.5732;Float;False;Property;_cloudHeight;cloudHeight;8;0;Create;True;0;0;False;0;0;1.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-1360.014,-627.5735;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1872.525,236.798;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;32;-1182.015,-630.5735;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-1607.974,70.96561;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1178.015,-473.5732;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;-1610.974,185.9656;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1200.183,96.91364;Float;False;Property;_NoiseMasterScale;Noise Master Scale;5;0;Create;True;0;0;False;0;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1270.284,-224.8915;Float;False;Property;_Noise1Scale;Noise 1 Scale;1;0;Create;True;0;0;False;0;0.53;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;-1006.015,-620.5735;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-1385.879,69.94257;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1370.62,185.7317;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1337.183,338.9136;Float;False;Property;_Noise2Scale;Noise 2 Scale;6;0;Create;True;0;0;False;0;0;1.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-940.4898,26.07069;Float;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;False;0;6622de1b0dc789c4e8a9b4a4b77f84df;6622de1b0dc789c4e8a9b4a4b77f84df;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-861.0148,-463.5731;Float;False;Property;_TaperPower;Taper Power;9;0;Create;True;0;0;False;0;4.26;1.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-987.975,322.7613;Float;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;36;-840.0147,-624.5735;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1029.925,-135.4064;Float;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;13;-688.5283,-188.5676;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-682,267.5;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;6622de1b0dc789c4e8a9b4a4b77f84df;6622de1b0dc789c4e8a9b4a4b77f84df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;37;-626.0143,-613.5735;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-295.5061,38.19888;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-405.4146,-615.2735;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;302.132,298.7446;Float;False;Property;_CloudCutoff;Cloud Cutoff;2;0;Create;True;0;0;False;0;0.06764707;0.024;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;93.78079,-503.0251;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;46;377.3674,-590.6786;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;612.132,60.74458;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;816.1321,58.74458;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;678.3016,308.7446;Float;False;Property;_CloudSoftness;Cloud Softness;3;0;Create;True;0;0;False;0;0.01;0.27;0.15;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;47;631.3064,-508.1812;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;860.0203,-604.7942;Float;False;Property;_Colorstr;Color str;11;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;1042.28,-492.4007;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;141.4607,-50.78016;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;22;995.1321,60.74458;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-376.0009,-286.758;Float;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;False;0;None;4ee51657529271e44a36e1857a62e079;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1312.218,-151.7436;Half;False;True;2;Half;ASEMaterialInspector;0;0;Standard;Attila_Herczeg/SH_CloudShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;29;0
WireConnection;30;1;31;2
WireConnection;6;0;25;0
WireConnection;32;0;30;0
WireConnection;9;0;3;1
WireConnection;9;1;3;3
WireConnection;34;0;35;0
WireConnection;10;0;6;0
WireConnection;10;1;6;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;24;0;9;0
WireConnection;24;1;10;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;26;0;28;0
WireConnection;26;1;11;0
WireConnection;26;2;27;0
WireConnection;36;0;33;0
WireConnection;14;0;15;0
WireConnection;14;1;24;0
WireConnection;14;2;27;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;7;0;12;0
WireConnection;7;1;26;0
WireConnection;37;0;36;0
WireConnection;37;1;38;0
WireConnection;16;0;13;1
WireConnection;16;1;7;1
WireConnection;39;0;37;0
WireConnection;45;0;39;0
WireConnection;45;1;16;0
WireConnection;46;0;39;0
WireConnection;46;1;45;0
WireConnection;20;0;16;0
WireConnection;20;1;18;0
WireConnection;21;0;20;0
WireConnection;47;0;46;0
WireConnection;57;0;58;0
WireConnection;57;1;47;0
WireConnection;43;0;16;0
WireConnection;43;1;39;0
WireConnection;43;2;44;1
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;0;0;57;0
WireConnection;0;9;22;0
ASEEND*/
//CHKSM=670C7C102013D04848F78BF97A2A80736520CFAC
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Attila_Herczeg/CloudShader"
{
	Properties
	{
		_TopTexture0("Top Texture 0", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.7
		_CloudColor("Cloud Color", Color) = (0.8113208,0.7845319,0.7845319,0)
		_EmissonPower("Emisson Power", Float) = 0.2
		_TilingNoise("Tiling Noise", Vector) = (0.02,0.02,0,0)
		_LightColorIntensity("Light Color Intensity", Float) = 0.1
		_OffsetPanner("Offset Panner", Float) = 0.49
		_FresnelPowerOuter("Fresnel Power Outer", Float) = 4
		_Tessellation("Tessellation", Float) = 6
		_LightColor("Light Color", Color) = (1,0.009791803,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha , Zero Zero
		
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#define ASE_TEXTURE_PARAMS(textureName) textureName

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _TopTexture0;
		uniform float2 _TilingNoise;
		uniform float _OffsetPanner;
		uniform float4 _CloudColor;
		uniform float _EmissonPower;
		uniform float4 _LightColor;
		uniform float _LightColorIntensity;
		uniform float _FresnelPowerOuter;
		uniform float _Tessellation;
		uniform float _Cutoff = 0.7;


		inline float4 TriplanarSamplingSV( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2Dlod( ASE_TEXTURE_PARAMS( topTexMap ), float4( tiling * worldPos.zy * float2( nsign.x, 1.0 ), 0, 0 ) ) );
			yNorm = ( tex2Dlod( ASE_TEXTURE_PARAMS( topTexMap ), float4( tiling * worldPos.xz * float2( nsign.y, 1.0 ), 0, 0 ) ) );
			zNorm = ( tex2Dlod( ASE_TEXTURE_PARAMS( topTexMap ), float4( tiling * worldPos.xy * float2( -nsign.z, 1.0 ), 0, 0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_2 = (_Tessellation).xxxx;
			return temp_cast_2;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float4 triplanar1 = TriplanarSamplingSV( _TopTexture0, ase_worldPos, ase_worldNormal, 1.0, _TilingNoise, 1.0, 0 );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( triplanar1 * float4( ase_vertexNormal , 0.0 ) * _OffsetPanner ).xyz;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult34 = dot( ase_worldlightDir , ase_worldNormal );
			o.Emission = ( ( _CloudColor * _EmissonPower ) + ( dotResult34 * ( _LightColor * _LightColorIntensity ) ) ).rgb;
			float4 triplanar1 = TriplanarSamplingSF( _TopTexture0, ase_worldPos, ase_worldNormal, 1.0, _TilingNoise, 1.0, 0 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV5 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode5 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV5, 0.2 ) );
			float fresnelNdotV19 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode19 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV19, _FresnelPowerOuter ) );
			float temp_output_22_0 = ( saturate( (0.0 + (( triplanar1.x + ( 1.0 - fresnelNode5 ) ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) ) * (0.0 + (( 1.0 - fresnelNode19 ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) );
			o.Alpha = saturate( temp_output_22_0 );
			clip( temp_output_22_0 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows noshadow exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
1921;1;1678;986;174.5423;646.36;1.686386;True;False
Node;AmplifyShaderEditor.RangedFloatNode;6;-514.8326,241.4872;Float;False;Constant;_FresnelPowerInner;Fresnel Power Inner;3;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;5;-282.8326,159.4872;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;3;-1338.982,44.63664;Float;False;Property;_TilingNoise;Tiling Noise;5;0;Create;True;0;0;False;0;0.02,0.02;0.02,0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;18;-217.1026,352.0429;Float;False;Property;_FresnelPowerOuter;Fresnel Power Outer;8;0;Create;True;0;0;False;0;4;5.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;7;-43.83264,168.4872;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;1;-968,31.5;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;1;Assets/Textures/VFXTextures/CloudTexture/T_Cloud_03.png;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;4;163.7028,-5.180898;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;19;14.8974,270.0429;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;253.8974,276.0429;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;9;488.1674,94.48724;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;37;1048.732,962.1501;Float;False;Property;_LightColor;Light Color;11;0;Create;True;0;0;False;0;1,0.009791803,0,0;1,0.6994326,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;1086.964,1226.47;Float;False;Property;_LightColorIntensity;Light Color Intensity;6;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;33;456.9117,567.1771;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;32;456.9117,776.1772;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;34;734.9117,683.1771;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;1276.591,1052.367;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;21;705.0618,102.023;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;737.4362,-367.5089;Float;False;Property;_EmissonPower;Emisson Power;4;0;Create;True;0;0;False;0;0.2;0.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;12;-603.8326,476.4872;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;487.2307,319.3763;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;29;704.3787,-552.0773;Float;False;Property;_CloudColor;Cloud Color;3;0;Create;True;0;0;False;0;0.8113208,0.7845319,0.7845319,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;887.0618,155.023;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;976.4362,-435.5089;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;11;-480.8326,579.4872;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-473.8326,738.4872;Float;False;Property;_OffsetPanner;Offset Panner;7;0;Create;True;0;0;False;0;0.49;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;13;-386.8326,511.4872;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1117.51,615.3692;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;27;-733.9811,-265.9094;Float;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;False;0;0.05,0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;24;902.0618,-142.977;Float;False;Property;_TranslucencyColor;Translucency Color;10;0;Create;True;0;0;False;0;0.5,0.4162361,0.3466981,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-85.83264,477.4872;Float;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;16;937.0375,297.0991;Float;False;Property;_Tessellation;Tessellation;9;0;Create;True;0;0;False;0;6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;25;-459.0672,-317.1858;Float;True;Spherical;World;True;Top Texture 1;_TopTexture1;white;0;Assets/Textures/VFXTextures/CloudTexture/T_Cloud_N.png;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;36;1323.208,444.834;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;23;1025.062,106.023;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1416.879,-42.39418;Float;False;True;6;Float;ASEMaterialInspector;0;0;Unlit;Attila_Herczeg/CloudShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.7;True;True;0;True;TransparentCutout;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.71;False;2;5;False;-1;10;False;-1;1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;3;6;0
WireConnection;7;0;5;0
WireConnection;1;3;3;0
WireConnection;4;0;1;1
WireConnection;4;1;7;0
WireConnection;19;3;18;0
WireConnection;17;0;19;0
WireConnection;9;0;4;0
WireConnection;34;0;33;0
WireConnection;34;1;32;0
WireConnection;39;0;37;0
WireConnection;39;1;38;0
WireConnection;21;0;9;0
WireConnection;12;0;1;0
WireConnection;20;0;17;0
WireConnection;22;0;21;0
WireConnection;22;1;20;0
WireConnection;31;0;29;0
WireConnection;31;1;30;0
WireConnection;13;0;12;0
WireConnection;35;0;34;0
WireConnection;35;1;39;0
WireConnection;10;0;13;0
WireConnection;10;1;11;0
WireConnection;10;2;14;0
WireConnection;25;3;27;0
WireConnection;36;0;31;0
WireConnection;36;1;35;0
WireConnection;23;0;22;0
WireConnection;0;2;36;0
WireConnection;0;9;23;0
WireConnection;0;10;22;0
WireConnection;0;11;10;0
WireConnection;0;14;16;0
ASEEND*/
//CHKSM=416490D2E43E8FAAC5B1D2E7D3883E666FBD302B
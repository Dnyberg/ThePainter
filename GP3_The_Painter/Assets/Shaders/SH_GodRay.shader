// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Attila_Herczeg/SH_Godray"
{
	Properties
	{
		_BrushTexture("Brush Texture", 2D) = "white" {}
		_FormTexture("Form Texture", 2D) = "white" {}
		_BaseColor("Base Color", Color) = (0.197633,0.6415094,0.1664293,0)
		_MainDetailTexture("Main Detail Texture", 2D) = "white" {}
		_NoiseTexture("Noise Texture", 2D) = "white" {}
		_DetailIntensity("Detail Intensity", Float) = 1
		_Scale("Scale", Float) = 1.55
		_ColorIntensity("Color Intensity", Float) = 0.5
		_BlendStr("Blend Str", Float) = -5
		_LightColorIntensity("Light Color Intensity", Float) = 0.1
		_UVScale("UV Scale", Float) = 1
		_LightColor("Light Color", Color) = (1,0.009791803,0,0)
		_VertexOffsetIntensity("Vertex Offset Intensity", Float) = 0
		_OpacityIntensity("Opacity Intensity", Range( 0 , 5)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
		};

		uniform float _VertexOffsetIntensity;
		uniform sampler2D _MainDetailTexture;
		uniform float4 _MainDetailTexture_ST;
		uniform float _DetailIntensity;
		uniform float4 _BaseColor;
		uniform sampler2D _BrushTexture;
		uniform float4 _BrushTexture_ST;
		uniform float _ColorIntensity;
		uniform float4 _LightColor;
		uniform float _LightColorIntensity;
		uniform float _OpacityIntensity;
		uniform sampler2D _NoiseTexture;
		uniform float _UVScale;
		uniform sampler2D _FormTexture;
		uniform float4 _FormTexture_ST;
		uniform float _Scale;
		uniform float _BlendStr;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 temp_output_128_0 = ( sin( ase_worldPos ) * ( _VertexOffsetIntensity * ( ( 1.0 - v.texcoord.xy.y ) * cos( _Time.y ) ) ) );
			float4 appendResult129 = (float4(temp_output_128_0.x , 0.0 , temp_output_128_0.xy));
			v.vertex.xyz += appendResult129.xyz;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainDetailTexture = i.uv_texcoord * _MainDetailTexture_ST.xy + _MainDetailTexture_ST.zw;
			float2 uv_BrushTexture = i.uv_texcoord * _BrushTexture_ST.xy + _BrushTexture_ST.zw;
			float4 tex2DNode113 = tex2D( _BrushTexture, uv_BrushTexture );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float dotResult136 = dot( ase_worldlightDir , ase_worldNormal );
			o.Emission = ( ( ( ( tex2D( _MainDetailTexture, uv_MainDetailTexture ) * _DetailIntensity ) * ( _BaseColor * tex2DNode113 ) ) * _ColorIntensity ) + ( dotResult136 * ( _LightColor * _LightColorIntensity ) ) ).rgb;
			float4 tex2DNode157 = tex2D( _NoiseTexture, ( i.uv_texcoord * _UVScale ) );
			float2 uv_FormTexture = i.uv_texcoord * _FormTexture_ST.xy + _FormTexture_ST.zw;
			float HeightMask161 = saturate(pow(((tex2DNode157.r*( ( tex2D( _FormTexture, uv_FormTexture ) * _Scale ) - tex2DNode157 ).r)*4)+(( ( tex2D( _FormTexture, uv_FormTexture ) * _Scale ) - tex2DNode157 ).r*2),_BlendStr));
			float clampResult151 = clamp( ( ( tex2DNode113.a * _OpacityIntensity ) * ( 1.0 - HeightMask161 ) ) , 0.0 , 1.0 );
			o.Alpha = clampResult151;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16702
1927;1;1666;980;965.4213;-291.1927;1.736091;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;152;-3508.275,1927.519;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;153;-3487.275,2191.52;Float;False;Property;_UVScale;UV Scale;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-3202.275,2032.519;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;156;-2858.285,1448.433;Float;True;Property;_FormTexture;Form Texture;1;0;Create;True;0;0;False;0;93040fc3ac65cf64ca830ffa2c73460e;93040fc3ac65cf64ca830ffa2c73460e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;155;-2746.675,1672.521;Float;False;Property;_Scale;Scale;6;0;Create;True;0;0;False;0;1.55;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-2524.676,1526.521;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;157;-2832.617,2000.586;Float;True;Property;_NoiseTexture;Noise Texture;4;0;Create;True;0;0;False;0;566130b4c7fa0164b8d8431b5e191a02;566130b4c7fa0164b8d8431b5e191a02;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;118;-681.3997,2147.78;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;117;-683.3997,1952.78;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;160;-2252.676,1534.521;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CosOpNode;119;-374.3998,2173.78;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;120;-383.3998,2005.78;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-1510.572,-248.0939;Float;False;Property;_BaseColor;Base Color;2;0;Create;True;0;0;False;0;0.197633,0.6415094,0.1664293,0;0.3862374,0.4509804,0.2039216,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;113;-1528.195,552.3588;Float;True;Property;_BrushTexture;Brush Texture;0;0;Create;True;0;0;False;0;e2be95ba8cb12f643adad0c91f42d3a9;a7bc463d999da714e98c89a244ce0379;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;159;-2206.276,1741.52;Float;False;Property;_BlendStr;Blend Str;8;0;Create;True;0;0;False;0;-5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;-1088.069,-964.3607;Float;True;Property;_MainDetailTexture;Main Detail Texture;3;0;Create;True;0;0;False;0;335a32816cb3e2a4889d5bdb1dbe5e77;29e227898e17fe145bfc5cb79d706078;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;148;-932.3622,-527.1682;Float;False;Property;_DetailIntensity;Detail Intensity;5;0;Create;True;0;0;False;0;1;3.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;133;-1200.334,991.3048;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;149;-1174.776,1230.986;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;139;-808.0471,1684.283;Float;False;Property;_LightColorIntensity;Light Color Intensity;9;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;138;-846.2786,1419.964;Float;False;Property;_LightColor;Light Color;15;0;Create;True;0;0;False;0;1,0.009791803,0,0;0.5188679,0.4352698,0.1884567,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;124;-158.5618,1606.411;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-172.4002,2097.78;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-747.3967,-635.5677;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-744.46,96.32765;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;131;138.4591,715.7578;Float;False;Property;_OpacityIntensity;Opacity Intensity;17;0;Create;True;0;0;False;0;1;1.22;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.HeightMapBlendNode;161;-1971.285,1582.433;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-301.5253,1837.842;Float;False;Property;_VertexOffsetIntensity;Vertex Offset Intensity;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;408.8084,628.6227;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-220.7852,123.2306;Float;False;Property;_ColorIntensity;Color Intensity;7;0;Create;True;0;0;False;0;0.5;0.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;17.47469,1878.842;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;126;87.43818,1650.411;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-352.3952,-442.6631;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;164;-1650.243,1785.771;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-618.4207,1510.181;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;136;-922.3344,1107.305;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;728.403,1089.264;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;34.07811,34.71349;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-447.16,1087.367;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;224.0833,1742.432;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;127;249.4382,1547.411;Float;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;129;537.4385,1410.411;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-3939.933,874.2742;Float;False;Property;_SubsurfaceDistortionModifier;Subsurface Distortion Modifier;14;0;Create;True;0;0;False;0;0.52;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;99;-2833.672,978.9965;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;100;-2718.389,660.4391;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;104;-2594.078,839.8322;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-3563.501,703.3732;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;85;-4297.029,793.4332;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;95;-3137.39,838.4393;Float;False;Property;_SSSPower;SSS Power;12;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;86;-4036.928,634.3328;Float;False;Object;World;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;98;-2889.389,819.4393;Float;False;Property;_SSSScale;SSS Scale;13;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;102;-2567.411,658.9141;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;151;918.4103,961.156;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;97;-2916.389,648.439;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;92;-3304.827,502.8959;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;87;-3803.928,636.3328;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;90;-3665.965,534.8964;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;103;-2687.389,418.4378;Float;False;Property;_SSSColor;SSS Color;10;0;Create;True;0;0;False;0;0.5377358,0.129361,0.129361,0;0.01526345,0.4622642,0.04953923,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;101;-2402.022,965.9517;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;94;-3090.102,665.6771;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-2331.389,627.4389;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NegateNode;93;-3263.061,686.037;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;371.754,852.7728;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;96;-3844.652,1058.923;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-3381.974,685.5701;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1220.891,797.8018;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Attila_Herczeg/SH_Godray;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;154;0;152;0
WireConnection;154;1;153;0
WireConnection;158;0;156;0
WireConnection;158;1;155;0
WireConnection;157;1;154;0
WireConnection;160;0;158;0
WireConnection;160;1;157;0
WireConnection;119;0;118;2
WireConnection;120;0;117;2
WireConnection;123;0;120;0
WireConnection;123;1;119;0
WireConnection;147;0;46;0
WireConnection;147;1;148;0
WireConnection;50;0;7;0
WireConnection;50;1;113;0
WireConnection;161;0;157;0
WireConnection;161;1;160;0
WireConnection;161;2;159;0
WireConnection;130;0;113;4
WireConnection;130;1;131;0
WireConnection;125;0;121;0
WireConnection;125;1;123;0
WireConnection;126;0;124;0
WireConnection;51;0;147;0
WireConnection;51;1;50;0
WireConnection;164;0;161;0
WireConnection;142;0;138;0
WireConnection;142;1;139;0
WireConnection;136;0;133;0
WireConnection;136;1;149;0
WireConnection;167;0;130;0
WireConnection;167;1;164;0
WireConnection;53;0;51;0
WireConnection;53;1;54;0
WireConnection;143;0;136;0
WireConnection;143;1;142;0
WireConnection;128;0;126;0
WireConnection;128;1;125;0
WireConnection;129;0;128;0
WireConnection;129;1;127;0
WireConnection;129;2;128;0
WireConnection;99;0;96;0
WireConnection;100;0;97;0
WireConnection;100;1;98;0
WireConnection;104;0;101;0
WireConnection;89;0;87;0
WireConnection;89;1;88;0
WireConnection;86;0;85;0
WireConnection;102;0;100;0
WireConnection;151;0;167;0
WireConnection;97;0;94;0
WireConnection;97;1;95;0
WireConnection;87;0;86;0
WireConnection;101;0;99;0
WireConnection;94;0;92;0
WireConnection;94;1;93;0
WireConnection;105;0;103;0
WireConnection;105;1;102;0
WireConnection;105;2;104;0
WireConnection;93;0;91;0
WireConnection;146;0;53;0
WireConnection;146;1;143;0
WireConnection;96;0;85;0
WireConnection;91;0;90;0
WireConnection;91;1;89;0
WireConnection;0;2;146;0
WireConnection;0;9;151;0
WireConnection;0;11;129;0
ASEEND*/
//CHKSM=283FC6CF7FF598B93B169987E23E7CF5DF07B29B
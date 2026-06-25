// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Dithering_Shader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_PlayerPos("PlayerPos", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 3
		_Hardness("Hardness", Float) = 0.8
		_NoiseSpeed("NoiseSpeed", Vector) = (-0.01,0.01,0,0)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_CutRadius("CutRadius", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float3 _PlayerPos;
		uniform float _Radius;
		uniform float _Hardness;
		uniform sampler2D _NoiseTex;
		uniform float2 _NoiseSpeed;
		uniform float _CutRadius;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			float dist3D52 = length( abs( ( ase_worldPos - _PlayerPos ) ) );
			float sphereMask77 = ( 1.0 - saturate( ( ( dist3D52 - _Radius ) / ( 1.0 - _Hardness ) ) ) );
			float3 worldToView55 = mul( UNITY_MATRIX_V, float4( ase_worldPos, 1 ) ).xyz;
			float2 worldViewXY57 = (worldToView55).xy;
			float3 worldToView59 = mul( UNITY_MATRIX_V, float4( _PlayerPos, 1 ) ).xyz;
			float2 playerViewXY62 = (worldToView59).xy;
			float sphereMask2D87 = ( 1.0 - saturate( ( ( distance( worldViewXY57 , playerViewXY62 ) - _Radius ) / 0.2 ) ) );
			float2 panner90 = ( 1.0 * _Time.y * _NoiseSpeed + i.uv_texcoord);
			float noise93 = tex2D( _NoiseTex, panner90 ).r;
			float lerpResult105 = lerp( ( ( 1.0 - sphereMask77 ) + ( 1.0 - sphereMask2D87 ) + noise93 ) , 1.0 , step( dist3D52 , _CutRadius ));
			clip( lerpResult105 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1410.4;80.8;1175.6;654.2;-419.051;-186.4877;1.559662;True;False
Node;AmplifyShaderEditor.CommentaryNode;58;142.77,-123.0969;Inherit;False;902.6988;235.7002;World view;4;54;55;56;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;53;71.35413,-814.3807;Inherit;False;971.8246;403.7206;Distance;6;47;49;48;50;51;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;63;347.9225,-400.1712;Inherit;False;672.3505;235.6;Player view;3;59;60;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;47;121.3541,-764.3807;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;49;136.3787,-596.2601;Inherit;False;Property;_PlayerPos;PlayerPos;1;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;54;192.7701,-67.99651;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;59;397.9225,-350.1712;Inherit;False;World;View;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;365.3787,-634.2601;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;55;425.4701,-73.0966;Inherit;False;World;View;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;56;658.1691,-73.09672;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;60;621.7214,-349.4531;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;50;544.3787,-633.2601;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;88;1222.914,-1184.012;Inherit;False;1385.813;405.6396;Sphere mask 2D;9;79;82;80;81;84;83;85;86;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LengthOpNode;51;684.3787,-634.2601;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;795.473,-348.0289;Inherit;False;playerViewXY;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;820.6687,-72.09678;Inherit;False;worldViewXY;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;78;1225.531,-695.4501;Inherit;False;1256.76;528.1027;Sphere mask;10;69;68;67;71;72;70;73;74;75;77;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;1274.941,-1046.975;Inherit;False;62;playerViewXY;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;818.3787,-638.2601;Inherit;False;dist3D;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;1272.914,-1134.012;Inherit;False;57;worldViewXY;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;69;1289.061,-529.341;Inherit;False;Property;_Radius;Radius;2;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;1275.531,-645.4501;Inherit;False;52;dist3D;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;1443.952,-419.7474;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;1439.952,-282.7476;Inherit;False;Property;_Hardness;Hardness;3;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;81;1514.104,-1104.328;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;1718.278,-1016.584;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;1705.927,-893.7722;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;72;1605.952,-345.7475;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;68;1546.608,-578.5144;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;83;1917.761,-951.9072;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;1237.253,-89.78598;Inherit;False;1140.885;358.729;Animated noise;5;89;90;91;92;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;70;1786.28,-464.0762;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;91;1345.486,106.7431;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;4;0;Create;True;0;0;0;False;0;False;-0.01,0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;74;1940.34,-463.2715;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;85;2061.927,-952.7722;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;89;1287.253,-39.78598;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;90;1606.318,30.19518;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;75;2098.94,-464.5715;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;86;2212.927,-951.7722;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;2379.927,-955.7722;Inherit;False;sphereMask2D;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;92;1820.308,3.412543;Inherit;True;Property;_NoiseTex;NoiseTex;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;2257.49,-467.2504;Inherit;False;sphereMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;2153.338,27.32108;Inherit;False;noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;856.7911,591.7701;Inherit;False;77;sphereMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;843.8906,728.4852;Inherit;False;87;sphereMask2D;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;96;1074.891,597.4852;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;98;1076.891,734.4852;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;1058.891,835.4852;Inherit;False;93;noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;1348.65,836.0332;Inherit;False;52;dist3D;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;1369.605,933.0204;Inherit;False;Property;_CutRadius;CutRadius;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;1316.891,683.4852;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;103;1567.81,873.3514;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;105;1711.07,548.0959;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2047.084,421.1666;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Dithering_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;59;0;49;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;55;0;54;0
WireConnection;56;0;55;0
WireConnection;60;0;59;0
WireConnection;50;0;48;0
WireConnection;51;0;50;0
WireConnection;62;0;60;0
WireConnection;57;0;56;0
WireConnection;52;0;51;0
WireConnection;81;0;79;0
WireConnection;81;1;80;0
WireConnection;82;0;81;0
WireConnection;82;1;69;0
WireConnection;72;0;71;0
WireConnection;72;1;73;0
WireConnection;68;0;67;0
WireConnection;68;1;69;0
WireConnection;83;0;82;0
WireConnection;83;1;84;0
WireConnection;70;0;68;0
WireConnection;70;1;72;0
WireConnection;74;0;70;0
WireConnection;85;0;83;0
WireConnection;90;0;89;0
WireConnection;90;2;91;0
WireConnection;75;0;74;0
WireConnection;86;0;85;0
WireConnection;87;0;86;0
WireConnection;92;1;90;0
WireConnection;77;0;75;0
WireConnection;93;0;92;1
WireConnection;96;0;95;0
WireConnection;98;0;97;0
WireConnection;99;0;96;0
WireConnection;99;1;98;0
WireConnection;99;2;100;0
WireConnection;103;0;101;0
WireConnection;103;1;104;0
WireConnection;105;0;99;0
WireConnection;105;2;103;0
WireConnection;0;10;105;0
ASEEND*/
//CHKSM=B0FE96AC1297C89E2A605F1414892F0263EA4455
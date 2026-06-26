// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Dithering_Shader"
{
	Properties
	{
		_PlayerPos("PlayerPos", Vector) = (0,0,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Radius("Radius", Float) = 3
		_NoiseSpeed("NoiseSpeed", Vector) = (-0.01,0.01,0,0)
		_NoiseTex("NoiseTex", 2D) = "white" {}
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
		uniform sampler2D _NoiseTex;
		uniform float2 _NoiseSpeed;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			float3 worldToView55 = mul( UNITY_MATRIX_V, float4( ase_worldPos, 1 ) ).xyz;
			float3 worldToView59 = mul( UNITY_MATRIX_V, float4( _PlayerPos, 1 ) ).xyz;
			float2 panner90 = ( 1.0 * _Time.y * _NoiseSpeed + i.uv_texcoord);
			float lerpResult105 = lerp( ( saturate( ( ( distance( (worldToView55).xy , (worldToView59).xy ) - _Radius ) / 0.2 ) ) + tex2D( _NoiseTex, panner90 ).r ) , 1.0 , step( length( abs( ( ase_worldPos - _PlayerPos ) ) ) , 0.0 ));
			clip( lerpResult105 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1410.4;80.8;1175.6;638.2;3154.253;677.5615;2.900681;True;False
Node;AmplifyShaderEditor.CommentaryNode;58;-751.4636,139.5232;Inherit;False;612.7719;217.0499;World view;3;54;56;55;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;53;-850.8443,659.4824;Inherit;False;722.8347;403.9322;Distance;5;51;50;48;49;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;54;-713.3355,201.4055;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;49;-807.6123,888.8037;Inherit;False;Property;_PlayerPos;PlayerPos;0;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;63;-533.4027,396.5396;Inherit;False;400.3033;216.62;Player view;2;60;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TransformPositionNode;59;-492.8937,444.9566;Inherit;False;World;View;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;55;-516.2366,196.3055;Inherit;False;World;View;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;56;-283.537,196.3053;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;88;88.8275,464.7514;Inherit;False;716.9797;384.7972;Sphere mask 2D;6;85;83;84;82;81;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;60;-269.0925,445.6747;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;81;119.6876,530.3061;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-52.42732,931.0649;Inherit;False;908.987;336.3527;Animated noise;4;92;90;89;91;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;69;127.7651,733.6768;Inherit;False;Property;_Radius;Radius;2;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;47;-822.637,720.6823;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;91;59.87398,1129.627;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;3;0;Create;True;0;0;0;False;0;False;-0.01,0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-578.6121,850.8035;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;84;311.5092,740.8597;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;323.8601,618.0491;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;89;1.641105,983.099;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;50;-399.6107,851.8035;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;83;523.3425,682.725;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;90;320.7071,1053.079;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;51;-259.6093,850.8035;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;85;667.5096,681.86;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;92;534.6942,1026.297;Inherit;True;Property;_NoiseTex;NoiseTex;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;99;935.8132,972.2031;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;103;1546.95,854.2932;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;105;1711.07,548.0959;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2024.284,305.2668;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Dithering_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;59;0;49;0
WireConnection;55;0;54;0
WireConnection;56;0;55;0
WireConnection;60;0;59;0
WireConnection;81;0;56;0
WireConnection;81;1;60;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;82;0;81;0
WireConnection;82;1;69;0
WireConnection;50;0;48;0
WireConnection;83;0;82;0
WireConnection;83;1;84;0
WireConnection;90;0;89;0
WireConnection;90;2;91;0
WireConnection;51;0;50;0
WireConnection;85;0;83;0
WireConnection;92;1;90;0
WireConnection;99;0;85;0
WireConnection;99;1;92;1
WireConnection;103;0;51;0
WireConnection;105;0;99;0
WireConnection;105;2;103;0
WireConnection;0;10;105;0
ASEEND*/
//CHKSM=6118C5D2FA925424776F8AFDECBA6C990A427BFC
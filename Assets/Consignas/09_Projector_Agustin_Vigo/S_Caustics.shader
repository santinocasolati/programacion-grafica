// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_Caustics"
{
	Properties
	{
		_T_Caustics("T_Caustics", 2D) = "white" {}
		_Escala("Escala", Float) = 3
		_velocidad1("velocidad1", Vector) = (0.04,0.015,0,0)
		_Escala2("Escala2", Float) = 5.5
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TintAgua("TintAgua", Color) = (0,0.8865161,1,0)
		_Float1("Float 1", Float) = 1.5

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset -1 , -1
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _T_Caustics;
			uniform float4x4 unity_Projector;
			uniform float _Escala;
			uniform float2 _velocidad1;
			uniform sampler2D _TextureSample0;
			uniform float _Escala2;
			uniform float4 _TintAgua;
			uniform float _Float1;
			float4 MyCustomExpression3( float4x4 M, float3 p )
			{
				 return mul(M, float4(p, 1.0));
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1 = v.vertex;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float4x4 M3 = unity_Projector;
				float3 p3 = i.ase_texcoord1.xyz;
				float4 localMyCustomExpression3 = MyCustomExpression3( M3 , p3 );
				float2 temp_output_8_0 = ( (localMyCustomExpression3).xy / (localMyCustomExpression3).w );
				
				
				finalColor = ( ( min( tex2D( _T_Caustics, ( ( temp_output_8_0 * _Escala ) + ( _Time.y * _velocidad1 ) ) ) , tex2D( _TextureSample0, ( ( temp_output_8_0 * _Escala2 ) + ( _Time.y * float2( -0.025,0.05 ) ) ) ) ) * _TintAgua ) * _Float1 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
180;73;1330;597;-50;225.5;1;True;False
Node;AmplifyShaderEditor.Matrix4X4Node;1;-572,-71.5;Inherit;False;Global;unity_Projector;unity_Projector ;0;0;Create;True;0;0;0;False;0;False;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.PosVertexDataNode;2;-494,53.5;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;3;-284,31.5;Inherit;False; return mul(M, float4(p, 1.0))@;4;False;2;True;M;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;In;;Inherit;False;True;p;FLOAT3;0,0,0;In;;Inherit;False;My Custom Expression;True;False;0;2;0;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;6;-64,28.5;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;7;-68,114.5;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;14;219,390.5;Inherit;False;Property;_velocidad1;velocidad1;2;0;Create;True;0;0;0;False;0;False;0.04,0.015;0.03,0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;20;457,39.5;Inherit;False;Constant;_velocidad2;velocidad2;4;0;Create;True;0;0;0;False;0;False;-0.025,0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;12;232,318.5;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;484,-107.5;Inherit;False;Property;_Escala2;Escala2;3;0;Create;True;0;0;0;False;0;False;5.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;228,61.5;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;247,223.5;Inherit;False;Property;_Escala;Escala;1;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;19;461,-28.5;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;486,-193.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;435,295.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;438,181.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;635,-29.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;756,-124.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;658,214.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;9;852,130.5;Inherit;True;Property;_T_Caustics;T_Caustics;0;0;Create;True;0;0;0;False;0;False;-1;c1344767fe62e7a4680632fd121f05f2;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;883,-130.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;c1344767fe62e7a4680632fd121f05f2;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;1183,215.5;Inherit;False;Property;_TintAgua;TintAgua;5;0;Create;True;0;0;0;False;0;False;0,0.8865161,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMinOpNode;23;1225,86.5;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;1387,92.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;28;1434,221.5;Inherit;False;Property;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;1532,91.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1681,91;Float;False;True;-1;2;ASEMaterialInspector;100;1;S_Caustics;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;-1;False;-1;-1;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;6;0;3;0
WireConnection;7;0;3;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;16;0;8;0
WireConnection;16;1;17;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;10;0;8;0
WireConnection;10;1;11;0
WireConnection;18;0;19;0
WireConnection;18;1;20;0
WireConnection;21;0;16;0
WireConnection;21;1;18;0
WireConnection;15;0;10;0
WireConnection;15;1;13;0
WireConnection;9;1;15;0
WireConnection;22;1;21;0
WireConnection;23;0;9;0
WireConnection;23;1;22;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;26;0;25;0
WireConnection;26;1;28;0
WireConnection;0;0;26;0
ASEEND*/
//CHKSM=0C18AA47C8F95FF2BE77C3D39CACC498A04AC2AC
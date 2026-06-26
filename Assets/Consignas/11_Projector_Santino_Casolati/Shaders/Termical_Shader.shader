// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Termical_Shader"
{
	Properties
	{
		
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
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
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
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

			
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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
				float4 color3 = IsGammaSpace() ? float4(0,0,1,1) : float4(0,0,1,1);
				float4 color4 = IsGammaSpace() ? float4(0,0.9898858,1,1) : float4(0,0.9771456,1,1);
				float2 texCoord8 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 lerpResult2 = lerp( color3 , color4 , ( texCoord8.y * 0.25 ));
				float4 color6 = IsGammaSpace() ? float4(0,1,0,0) : float4(0,1,0,0);
				float4 lerpResult5 = lerp( lerpResult2 , color6 , ( texCoord8.y * 0.5 ));
				float4 color11 = IsGammaSpace() ? float4(1,1,0,0) : float4(1,1,0,0);
				float4 lerpResult13 = lerp( lerpResult5 , color11 , ( texCoord8.y * 0.75 ));
				float4 color14 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
				float4 lerpResult16 = lerp( lerpResult13 , color14 , texCoord8.y);
				
				
				finalColor = lerpResult16;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
1410.4;80.8;1175.6;638.2;1542.446;431.5793;2.48114;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1112.783,111.2049;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-775.8657,-354.7296;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,0,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-776.8657,-182.7296;Inherit;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;0;False;0;False;0,0.9898858,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-786.2832,73.27961;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2;-473.3871,-104.5436;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;-520.5656,39.77005;Inherit;False;Constant;_Color2;Color 2;0;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-449.5815,234.4798;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;5;-207.6657,66.8704;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;11;-201.9,254.7875;Inherit;False;Constant;_Color3;Color 2;0;0;Create;True;0;0;0;False;0;False;1,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-130.9159,449.4972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;110.9996,281.8878;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;14;131.9292,434.2309;Inherit;False;Constant;_Color4;Color 2;0;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;16;444.8292,461.3315;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;677.6269,452.9271;Float;False;True;-1;2;ASEMaterialInspector;100;1;Termical_Shader;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;0;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;9;0;8;2
WireConnection;2;0;3;0
WireConnection;2;1;4;0
WireConnection;2;2;9;0
WireConnection;10;0;8;2
WireConnection;5;0;2;0
WireConnection;5;1;6;0
WireConnection;5;2;10;0
WireConnection;12;0;8;2
WireConnection;13;0;5;0
WireConnection;13;1;11;0
WireConnection;13;2;12;0
WireConnection;16;0;13;0
WireConnection;16;1;14;0
WireConnection;16;2;8;2
WireConnection;0;0;16;0
ASEEND*/
//CHKSM=143044FAF6130B9B317C2132A297086463F74D5E
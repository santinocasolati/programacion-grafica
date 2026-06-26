// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_Water2d"
{
	Properties
	{
		_VelOlas("Vel Olas", Float) = 2
		_Cant_Olas("Cant_Olas", Float) = 8
		_altura("altura", Float) = 0.5
		_Opacity("Opacity", Float) = 0.7
		_Nivel("Nivel", Float) = 1
		_Distorcion("Distorcion", Float) = 0.02
		_Tinte("Tinte", Float) = 0.4
		_Tiling_Agua("Tiling_Agua", Vector) = (1,1,0,0)
		_Texture_Agua("Texture_Agua", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		GrabPass{ }

		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
			#else
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
			#endif


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
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform float _Distorcion;
			uniform float2 _Tiling_Agua;
			uniform float _Cant_Olas;
			uniform float _VelOlas;
			uniform float _altura;
			uniform float _Nivel;
			uniform float _Opacity;
			uniform float _Tinte;
			uniform sampler2D _Texture_Agua;
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
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
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
				float4 screenPos = i.ase_texcoord1;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float2 texCoord21 = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float4 screenColor32 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + ( sin( ( ( (texCoord21).x * 20.0 ) + ( _Time.y * 3.0 ) ) ) * _Distorcion ) ).xy);
				float4 color16 = IsGammaSpace() ? float4(0,0.5982008,1,0) : float4(0,0.3164508,1,0);
				float2 texCoord1 = i.ase_texcoord2.xy * _Tiling_Agua + float2( 0,0 );
				float temp_output_15_0 = step( ( ( sin( ( ( (texCoord1).x * _Cant_Olas ) + ( _Time.y * _VelOlas ) ) ) * _altura ) + _Nivel ) , (texCoord1).y );
				float4 appendResult19 = (float4(color16.r , color16.g , color16.b , ( temp_output_15_0 * _Opacity )));
				float4 lerpResult35 = lerp( screenColor32 , appendResult19 , _Tinte);
				
				
				finalColor = ( ( lerpResult35 * temp_output_15_0 ) * tex2D( _Texture_Agua, texCoord1 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
100;73;1717;687;-1239.644;85.74692;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;41;-362.1819,-179.9605;Inherit;False;819.8984;498.4404;Controla la repetición de la textura;7;8;4;2;3;1;38;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;38;-312.1819,-96.52659;Inherit;False;Property;_Tiling_Agua;Tiling_Agua;7;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-93.45531,-108.1043;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;43;3.73217,351.7228;Inherit;False;1135.544;462.2398;REFRACCIÓN;10;23;31;22;30;34;21;27;25;29;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;483.465,-133.1594;Inherit;False;942.77;352.1715;Olas procedurales:;9;9;10;12;20;11;13;5;6;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;220.0368,32.42963;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;2;243.9252,-144.0568;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;283.6477,116.001;Inherit;False;Property;_VelOlas;Vel Olas;0;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;416.4667,-15.91873;Inherit;False;Property;_Cant_Olas;Cant_Olas;1;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;533.465,82.81149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;53.73217,551.8939;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;561.5887,-83.15938;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;310.7754,662.5456;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;708.5658,0.1113894;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;287.2518,540.3432;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;496.1897,652.5226;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;833.3655,89.81111;Inherit;False;Property;_altura;altura;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;10;852.8657,-1.188748;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;497.3864,547.2213;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;1018.542,103.0121;Inherit;False;Property;_Nivel;Nivel;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;995.8645,0.1112902;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;643.6689,609.549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;1138.789,0.1111987;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;3;226.4862,202.4799;Inherit;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;794.0859,697.9626;Inherit;False;Property;_Distorcion;Distorcion;5;0;Create;True;0;0;0;False;0;False;0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;22;790.641,609.5495;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;15;1274.235,77.33551;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;1317.373,234.9783;Inherit;False;Property;_Opacity;Opacity;3;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;964.0209,610.6974;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;34;896.2763,401.7228;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;44;1456.27,-165.8781;Inherit;False;788.731;359.0655;Color + texture;4;39;19;16;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;1484.16,78.71225;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;1506.27,-115.8781;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;0,0.5982008,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;45;1846.324,223.2247;Inherit;False;628.6809;293.9835;refracción + olas;4;37;40;36;35;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;1187.327,373.9904;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;32;1349.225,368.2491;Inherit;False;Global;_GrabScreen0;Grab Screen 0;6;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;19;1722.724,10.18741;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;36;1912.323,401.2082;Inherit;False;Property;_Tinte;Tinte;6;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;35;1896.324,285.9799;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;39;1925.001,-83.75072;Inherit;True;Property;_Texture_Agua;Texture_Agua;8;0;Create;True;0;0;0;False;0;False;-1;cf361f83cb053f5438c8089a8df15ba6;cf361f83cb053f5438c8089a8df15ba6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;2091.337,282.1657;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;2313.005,273.2247;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2515.339,270.6482;Float;False;True;-1;2;ASEMaterialInspector;100;1;S_Water2d;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;1;0;38;0
WireConnection;2;0;1;0
WireConnection;6;0;4;0
WireConnection;6;1;7;0
WireConnection;5;0;2;0
WireConnection;5;1;8;0
WireConnection;9;0;5;0
WireConnection;9;1;6;0
WireConnection;25;0;21;0
WireConnection;28;0;27;0
WireConnection;10;0;9;0
WireConnection;29;0;25;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;23;0;29;0
WireConnection;23;1;28;0
WireConnection;13;0;11;0
WireConnection;13;1;20;0
WireConnection;3;0;1;0
WireConnection;22;0;23;0
WireConnection;15;0;13;0
WireConnection;15;1;3;0
WireConnection;30;0;22;0
WireConnection;30;1;31;0
WireConnection;17;0;15;0
WireConnection;17;1;18;0
WireConnection;33;0;34;0
WireConnection;33;1;30;0
WireConnection;32;0;33;0
WireConnection;19;0;16;1
WireConnection;19;1;16;2
WireConnection;19;2;16;3
WireConnection;19;3;17;0
WireConnection;35;0;32;0
WireConnection;35;1;19;0
WireConnection;35;2;36;0
WireConnection;39;1;1;0
WireConnection;37;0;35;0
WireConnection;37;1;15;0
WireConnection;40;0;37;0
WireConnection;40;1;39;0
WireConnection;0;0;40;0
ASEEND*/
//CHKSM=E21B300FEB119722DBFC0853897CA781751F1BF0
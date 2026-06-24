// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Binoculars_Shader"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_LensOffset("LensOffset", Float) = 10
		_LensRadius("LensRadius", Float) = 4
		_LensSoftness("LensSoftness", Float) = 0.005
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend One Zero
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityShaderVariables.cginc"

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord2 : TEXCOORD2;
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float _LensRadius;
			uniform float _LensSoftness;
			uniform float _LensOffset;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				float4 ase_clipPos = UnityObjectToClipPos(IN.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				OUT.ase_texcoord2 = screenPos;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_TextureSample0 = IN.texcoord.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float temp_output_31_0 = ( _LensRadius - _LensSoftness );
				float temp_output_32_0 = ( _LensRadius + _LensSoftness );
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 break12 = ( ase_screenPosNorm - float4( float2( 0.5,0.5 ), 0.0 , 0.0 ) );
				float temp_output_9_0 = ( _ScreenParams.x / _ScreenParams.y );
				float2 appendResult14 = (float2(( break12.x * temp_output_9_0 ) , break12.y));
				float temp_output_18_0 = ( temp_output_9_0 * _LensOffset );
				float2 appendResult19 = (float2(temp_output_18_0 , 0.0));
				float smoothstepResult28 = smoothstep( temp_output_31_0 , temp_output_32_0 , length( ( appendResult14 - appendResult19 ) ));
				float2 appendResult20 = (float2(-temp_output_18_0 , 0.0));
				float smoothstepResult33 = smoothstep( temp_output_31_0 , temp_output_32_0 , length( ( appendResult14 - appendResult20 ) ));
				float4 lerpResult41 = lerp( float4( 0,0,0,0 ) , tex2D( _TextureSample0, uv_TextureSample0 ) , saturate( ( ( 1.0 - smoothstepResult28 ) + ( 1.0 - smoothstepResult33 ) ) ));
				
				half4 color = lerpResult41;
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
1410.4;80.8;1175.6;658.2;-1148.412;204.0406;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;10;-1237.618,-165.1518;Inherit;False;399.0035;254;Aspect Ratio;2;6;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;-1356.161,-622.9451;Inherit;False;503.6;396.3369;Center UV;3;1;2;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;22;-946.4102,127.8468;Inherit;False;730.0058;374.3567;Lens Position;5;16;18;20;21;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1;-1306.161,-572.9453;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;3;-1280.285,-388.8087;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScreenParams;6;-1187.618,-115.1518;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;-991.0146,-91.50826;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;15;-787.0436,-343.7162;Inherit;False;528.2374;280.77;Corrected X aspect ratio;3;13;12;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2;-1018.158,-457.9456;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-896.4102,252.3948;Inherit;False;Property;_LensOffset;LensOffset;0;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-656.1082,235.3203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;12;-737.0436,-293.7162;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-575.3315,-292.654;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;21;-509.8681,367.4035;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-378.8681,368.4035;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;27;-14.75454,70.11807;Inherit;False;423.7603;359.3;Distance to each lens center;4;24;23;25;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;38;435.2644,78.02992;Inherit;False;1263.823;545.0704;Binoculars Mask;10;32;31;28;33;30;29;34;35;36;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-419.6061,-196.7463;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-377.2043,177.8468;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;29;494.9733,381.6585;Inherit;False;Property;_LensRadius;LensRadius;1;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;35.24546,295.6181;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;39.14545,120.1181;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;485.2644,490.8236;Inherit;False;Property;_LensSoftness;LensSoftness;2;0;Create;True;0;0;0;False;0;False;0.005;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;26;253.0057,298.5719;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;25;248.0057,122.5719;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;696.9545,378.3623;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;700.7545,489.3003;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;28;993.3831,128.0299;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;988.1782,303.2331;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;1188.439,128.5654;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;35;1190.875,305.1427;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;1382.065,222.334;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;37;1534.287,223.5518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;1789.532,380.2988;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;41;2153.407,180.9362;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2385.418,179.4809;Float;False;True;-1;2;ASEMaterialInspector;0;4;Binoculars_Shader;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;True;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;9;0;6;1
WireConnection;9;1;6;2
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;18;0;9;0
WireConnection;18;1;16;0
WireConnection;12;0;2;0
WireConnection;13;0;12;0
WireConnection;13;1;9;0
WireConnection;21;0;18;0
WireConnection;20;0;21;0
WireConnection;14;0;13;0
WireConnection;14;1;12;1
WireConnection;19;0;18;0
WireConnection;24;0;14;0
WireConnection;24;1;20;0
WireConnection;23;0;14;0
WireConnection;23;1;19;0
WireConnection;26;0;24;0
WireConnection;25;0;23;0
WireConnection;31;0;29;0
WireConnection;31;1;30;0
WireConnection;32;0;29;0
WireConnection;32;1;30;0
WireConnection;28;0;25;0
WireConnection;28;1;31;0
WireConnection;28;2;32;0
WireConnection;33;0;26;0
WireConnection;33;1;31;0
WireConnection;33;2;32;0
WireConnection;34;0;28;0
WireConnection;35;0;33;0
WireConnection;36;0;34;0
WireConnection;36;1;35;0
WireConnection;37;0;36;0
WireConnection;41;1;39;0
WireConnection;41;2;37;0
WireConnection;0;0;41;0
ASEEND*/
//CHKSM=D92C80D2A825ABA0F7160B83D6DD71CE8EDA280E
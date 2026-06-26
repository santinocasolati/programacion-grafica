// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WakeUp"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_WakeAmount("_WakeAmount", Range( 0 , 1)) = 0
		_MinBrightness("_MinBrightness", Range( 0 , 1)) = 0.65
		_SlitSoftness("_SlitSoftness", Range( 0 , 0.2)) = 0
		_MaxOpen("_MaxOpen", Range( 0 , 0.5)) = 0.5

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _WakeAmount;
			uniform float _MinBrightness;
			uniform float _MaxOpen;
			uniform float _SlitSoftness;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 texCoord7 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode5 = tex2D( _MainTex, texCoord7 );
				float grayscale20 = Luminance(tex2DNode5.rgb);
				float4 temp_cast_1 = (grayscale20).xxxx;
				float4 lerpResult21 = lerp( temp_cast_1 , tex2DNode5 , _WakeAmount);
				float4 RecoveredColor22 = lerpResult21;
				float lerpResult23 = lerp( _MinBrightness , 1.0 , _WakeAmount);
				float4 BrightScene28 = ( ( RecoveredColor22 * lerpResult23 ) * RecoveredColor22 );
				float OpenHalf34 = ( _WakeAmount * _MaxOpen );
				float SoftStart59 = ( OpenHalf34 - _SlitSoftness );
				float DistanceFromCenter11 = abs( ( texCoord7.y - 0.5 ) );
				float smoothstepResult60 = smoothstep( SoftStart59 , OpenHalf34 , DistanceFromCenter11);
				float EyeMask65 = ( 1.0 - smoothstepResult60 );
				

				finalColor = ( BrightScene28 * EyeMask65 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
207;73;2008;993;1459.426;450.3999;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-1781.765,559.7946;Inherit;False;Property;_WakeAmount;_WakeAmount;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1726.545,-96.88017;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;6;-1650.728,-263.6768;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1788.131,811.2681;Inherit;False;Property;_MaxOpen;_MaxOpen;3;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1444.24,712.5502;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1350.19,-174.021;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1251.4,724.3215;Inherit;False;OpenHalf;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;-1415.932,53.87713;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1320.538,845.8574;Inherit;False;Property;_SlitSoftness;_SlitSoftness;2;0;Create;True;0;0;0;False;0;False;0;0.04;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;20;-859.9393,-169.495;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-680.054,-5.267912;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;10;-1218.021,97.78872;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;-981.8508,774.9466;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1786.794,333.0435;Inherit;False;Property;_MinBrightness;_MinBrightness;1;0;Create;True;0;0;0;False;0;False;0.65;0.65;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-1076.985,96.17883;Inherit;False;DistanceFromCenter;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-321.2944,34.63637;Inherit;False;RecoveredColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-790.8508,792.9466;Inherit;False;SoftStart;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-246.5216,682.9143;Inherit;False;34;OpenHalf;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-247.5216,589.9143;Inherit;False;59;SoftStart;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-278.4177,486.6567;Inherit;False;11;DistanceFromCenter;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-1419.765,245.9351;Inherit;False;22;RecoveredColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;23;-1400.039,361.9344;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1041.522,361.2942;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1082.298,487.9241;Inherit;False;22;RecoveredColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;60;17.6785,565.5139;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-784.3384,392.4455;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;64;231.4994,562.4443;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-628.0756,387.8145;Inherit;False;BrightScene;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;420.7342,563.3788;Inherit;False;EyeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-51.06177,-55.29972;Inherit;False;28;BrightScene;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-49.25209,86.19257;Inherit;False;65;EyeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;216.8015,11.04391;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;416,28.59998;Float;False;True;-1;2;ASEMaterialInspector;0;2;WakeUp;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;12;0;1;0
WireConnection;12;1;4;0
WireConnection;5;0;6;0
WireConnection;5;1;7;0
WireConnection;34;0;12;0
WireConnection;9;0;7;2
WireConnection;20;0;5;0
WireConnection;21;0;20;0
WireConnection;21;1;5;0
WireConnection;21;2;1;0
WireConnection;10;0;9;0
WireConnection;58;0;34;0
WireConnection;58;1;3;0
WireConnection;11;0;10;0
WireConnection;22;0;21;0
WireConnection;59;0;58;0
WireConnection;23;0;2;0
WireConnection;23;2;1;0
WireConnection;24;0;25;0
WireConnection;24;1;23;0
WireConnection;60;0;63;0
WireConnection;60;1;61;0
WireConnection;60;2;62;0
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;64;0;60;0
WireConnection;28;0;26;0
WireConnection;65;0;64;0
WireConnection;29;0;30;0
WireConnection;29;1;31;0
WireConnection;0;0;29;0
ASEEND*/
//CHKSM=C3A49BC9A38D0B1C007C20810331C4D059422262
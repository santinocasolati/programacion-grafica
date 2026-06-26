// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DamageHeal"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_DamageAmount("_DamageAmount", Range( 0 , 1)) = 0
		_HealAmount("_HealAmount", Range( 0 , 1)) = 0
		_DamageColor("_DamageColor", Color) = (1,0,0,1)
		_HealColor("_HealColor", Color) = (0,1,0.2745098,1)
		_VignetteInner("_VignetteInner", Range( 0 , 1)) = 0.25
		_VignetteOuter("_VignetteOuter", Range( 0 , 1)) = 0.65
		_PulseSpeed("_PulseSpeed", Float) = 5

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
			#include "UnityShaderVariables.cginc"


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
			
			uniform float _DamageAmount;
			uniform float4 _DamageColor;
			uniform float _VignetteInner;
			uniform float _VignetteOuter;
			uniform float _PulseSpeed;
			uniform float4 _HealColor;
			uniform float _HealAmount;


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
				float2 texCoord10 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode9 = tex2D( _MainTex, texCoord10 );
				float grayscale25 = Luminance(tex2DNode9.rgb);
				float4 temp_cast_1 = (grayscale25).xxxx;
				float4 lerpResult27 = lerp( tex2DNode9 , temp_cast_1 , ( _DamageAmount * 0.5 ));
				float4 DamagedBase28 = lerpResult27;
				float smoothstepResult15 = smoothstep( _VignetteInner , _VignetteOuter , length( ( texCoord10 - float2( 0.5,0.5 ) ) ));
				float VignetteMask18 = smoothstepResult15;
				float Pulse24 = ( ( sin( ( _Time.y * _PulseSpeed ) ) * 0.25 ) + 0.75 );
				float DamageMask33 = ( ( _DamageAmount * VignetteMask18 ) * Pulse24 );
				float4 lerpResult34 = lerp( DamagedBase28 , _DamageColor , DamageMask33);
				float4 DamageResult35 = lerpResult34;
				float HealMask40 = ( ( _HealAmount * VignetteMask18 ) * Pulse24 );
				float4 lerpResult41 = lerp( DamageResult35 , _HealColor , HealMask40);
				

				finalColor = lerpResult41;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
168;72.66667;1267.333;659;1065.423;76.8408;3.14426;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1070.166,964.6586;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-1222.13,1914.385;Inherit;False;Property;_PulseSpeed;_PulseSpeed;6;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-1204.932,1577.045;Inherit;False;Constant;_Center1;Center;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;19;-1235.358,1806.128;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-923.3837,1429.944;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-988.0671,1822.823;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;21;-817.8187,1838.132;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-804.1868,1655.69;Inherit;False;Property;_VignetteOuter;_VignetteOuter;5;0;Create;True;0;0;0;False;0;False;0.65;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-800.2905,1547.368;Inherit;False;Property;_VignetteInner;_VignetteInner;4;0;Create;True;0;0;0;False;0;False;0.25;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;14;-668.7246,1442.598;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-687.3972,1906.375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;15;-475.7513,1466.324;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-538.8682,1958.467;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;8;-1034.509,790.3373;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-277.8384,1462.653;Inherit;False;VignetteMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-384.9504,1078.487;Inherit;False;Property;_DamageAmount;_DamageAmount;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-322.5674,1233.072;Inherit;False;18;VignetteMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-373.305,1966.15;Inherit;False;Pulse;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-687.8475,808.1656;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-40.43018,1178.272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-36.59351,928.5466;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;25;-313.3145,889.063;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-60.88172,1309.327;Inherit;False;24;Pulse;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;677.077,1228.3;Inherit;False;18;VignetteMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;181.4435,813.1778;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;144.515,1216.519;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;679.4944,1101.6;Inherit;False;Property;_HealAmount;_HealAmount;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;990.0886,1300.158;Inherit;False;24;Pulse;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;1014.585,1163.451;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;307.5378,1258.578;Inherit;False;DamageMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;337.9499,1037.809;Inherit;False;Property;_DamageColor;_DamageColor;2;0;Create;True;0;0;0;False;0;False;1,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;379.766,933.8572;Inherit;False;DamagedBase;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;34;658.8856,942.7801;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;1209.692,1185.198;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;1370.342,1196.989;Inherit;False;HealMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;1404.502,1016.427;Inherit;False;Property;_HealColor;_HealColor;3;0;Create;True;0;0;0;False;0;False;0,1,0.2745098,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;863.2443,943.1754;Inherit;False;DamageResult;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;41;1767.688,948.8519;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2029.194,952.3989;Float;False;True;-1;2;ASEMaterialInspector;0;2;DamageHeal;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;12;0;10;0
WireConnection;12;1;13;0
WireConnection;20;0;19;0
WireConnection;20;1;7;0
WireConnection;21;0;20;0
WireConnection;14;0;12;0
WireConnection;22;0;21;0
WireConnection;15;0;14;0
WireConnection;15;1;5;0
WireConnection;15;2;6;0
WireConnection;23;0;22;0
WireConnection;18;0;15;0
WireConnection;24;0;23;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;29;0;1;0
WireConnection;29;1;30;0
WireConnection;26;0;1;0
WireConnection;25;0;9;0
WireConnection;27;0;9;0
WireConnection;27;1;25;0
WireConnection;27;2;26;0
WireConnection;31;0;29;0
WireConnection;31;1;32;0
WireConnection;36;0;2;0
WireConnection;36;1;37;0
WireConnection;33;0;31;0
WireConnection;28;0;27;0
WireConnection;34;0;28;0
WireConnection;34;1;3;0
WireConnection;34;2;33;0
WireConnection;38;0;36;0
WireConnection;38;1;39;0
WireConnection;40;0;38;0
WireConnection;35;0;34;0
WireConnection;41;0;35;0
WireConnection;41;1;4;0
WireConnection;41;2;40;0
WireConnection;0;0;41;0
ASEEND*/
//CHKSM=6C847789B47AA4BE99683FF453C182B89CEE2864
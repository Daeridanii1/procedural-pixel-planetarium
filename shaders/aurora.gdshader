shader_type spatial;

render_mode cull_disabled;

instance uniform vec4 color0 : source_color = vec4(1.);
instance uniform vec4 color1 : source_color = vec4(1.);
instance uniform float scale = 12.0;
instance uniform float extent = 1.0;

void fragment() {
	ALBEDO = vec3(0.);
	ALPHA = 
		clamp(
			cos(
				sin(UV.x * scale) * 12.
			) + 2.0 *  abs(sin(UV.y * 70.))
			- 
			pow(
				1.0 - (abs(UV.y * 2.0 - 1.0)),
			scale / 10000000.0)
		, 0., 1.);
	EMISSION = mix(color0.rgb, color1.rgb, sin(UV.x * 16. + TIME));
}

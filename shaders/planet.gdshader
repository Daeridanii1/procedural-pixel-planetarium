shader_type spatial;
render_mode unshaded, diffuse_toon;

instance uniform vec4 color0 : source_color = vec4(1);
instance uniform vec4 color1 : source_color = vec4(1);
instance uniform vec4 color2 : source_color = vec4(1);
instance uniform vec4 color3 : source_color = vec4(1);
instance uniform vec4 color4 : source_color = vec4(1);
instance uniform vec4 color_shadow : source_color = vec4(0., 0., 0., 1.);

instance uniform float noise_mult = 1.0;
instance uniform float crater_mult = 1.0;
instance uniform float poles_mult = 1.0;

uniform vec3 light_vector = vec3(1.);

uniform sampler2D NOISE_PATTERN;
uniform sampler2D VORONOI_PATTERN;

void fragment() {
	float noiseValue = texture(NOISE_PATTERN, UV).x;
	float voronoiValue = texture(VORONOI_PATTERN, UV).x;
	
	float ramp = (noiseValue * noise_mult) + (pow(1. - voronoiValue, 16.) * crater_mult);
	
	vec3 col = mix(color0.rgb, color1.rgb, step(ramp, 0.6));
	col = mix(col, color2.rgb, step(ramp, 0.5));
	col = mix(col, color3.rgb, step(ramp, 0.4));
	col = mix(col, color4.rgb, step(ramp, 0.25));
	
	col = mix(col, color4.rgb, round(abs(UV.y - 0.5) * 2.0 - 0.2 + ramp * 0.1) * poles_mult);
	
	vec4 world_nrm = inverse(MODEL_MATRIX) * INV_VIEW_MATRIX * vec4(NORMAL, 0.0);
	float light_intensity = step(dot(world_nrm.xyz, light_vector), 0);
	
	col *= mix(color_shadow.rgb, vec3(1.) ,light_intensity);
	
	ALBEDO = col;
	ROUGHNESS = 0.0;
	SPECULAR = 0.0;
}


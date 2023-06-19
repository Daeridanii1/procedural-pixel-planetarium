shader_type spatial;
render_mode unshaded;
uniform sampler2D NOISE_PATTERN;

uniform vec4 background_color : source_color = vec4(0., 0., 0., 1.);
uniform vec4 star_color : source_color = vec4(1., 1., 1., 1.);

void fragment() {
	float noiseValue = texture(NOISE_PATTERN, UV).x;
	noiseValue = pow(noiseValue, 8.);
	vec3 color = mix(background_color.rgb, star_color.rgb, noiseValue);
	ALBEDO = color;
}

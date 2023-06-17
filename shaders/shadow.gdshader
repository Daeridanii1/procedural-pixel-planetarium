shader_type spatial;
render_mode unshaded;

uniform vec3 light_vector = vec3(1.);

void fragment() {
	vec4 world_nrm = inverse(MODEL_MATRIX) * INV_VIEW_MATRIX * vec4(NORMAL, 0.0);
	float light_intensity = step(dot(world_nrm.xyz, light_vector), 0.2);
	ALBEDO = vec3(light_intensity);
}

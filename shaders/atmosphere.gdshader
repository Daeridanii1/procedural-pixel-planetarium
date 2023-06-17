shader_type spatial;

void fragment() {
	ALBEDO = vec3(0.);
	ALBEDO.r = abs(1. - length(sin(UV * 8.)));
}

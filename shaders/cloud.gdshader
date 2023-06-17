shader_type spatial;
render_mode unshaded;

uniform vec4 color : source_color = vec4(1.);
uniform vec4 shadow_color : source_color = vec4(0.5);

void fragment() {
	//vec4 world_pos = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	ALBEDO = color.rgb; //* step(sin(1. - world_pos.x * 2.0) * cos(1. - world_pos.z * 1.0), 0.314);
}

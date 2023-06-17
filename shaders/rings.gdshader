shader_type spatial;
render_mode cull_disabled, diffuse_toon;

uniform sampler2D RING_NOISE;

void fragment() {
	vec2 st = UV * 2.0 - vec2(1.0, 1.0);
	float rings = texture(RING_NOISE, vec2(distance(st, vec2(0.)))).x;
	rings = pow(rings, 4.0);
	rings = step(rings, 0.1);
	rings *= step(distance(st, vec2(0.)), 1.0);
	rings *= 1. - step(distance(st, vec2(0.)), 0.6);
	ALPHA = rings;
	ROUGHNESS = 0.0;
}

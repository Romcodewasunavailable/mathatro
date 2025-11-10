shader_type canvas_item;

uniform sampler2D noise;

uniform float border_thickness = 4.0;
uniform float num_stripes = 2.0;

instance uniform vec4 fill_color : source_color = vec4(1.0);
instance uniform vec2 size = vec2(40.0);

float sd_rounded_box(in vec2 p, in vec2 b, in vec4 r) {
	r.xy = (p.x > 0.0) ? r.xy : r.zw;
	r.x = (p.y > 0.0) ? r.x : r.y;
	vec2 q = abs(p) - b + r.x;
	return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

void fragment() {
	vec2 center_position = (UV - 0.5) * size;

	float fill_sd = sd_rounded_box(center_position, size / 2.0, vec4(8.0));
	float fill_fade = smoothstep(0.0, -1.0, fill_sd);

	float angle = atan(center_position.y, center_position.x);
	float stripe_fade = mod(angle - TIME, PI * 2.0 / num_stripes) / (PI * 2.0 / num_stripes);
	float border_fade = smoothstep(
		-border_thickness,
		-border_thickness + 1.0,
		fill_sd
	) * smoothstep(
		0.0,
		1.0,
		abs(stripe_fade - 0.5) * 2.0
	);

	float noise_fade = mix(
		texture(noise, 0.25 + SCREEN_UV / 2.0 + 0.1 * vec2(
			sin(TIME * 0.05),
			cos(TIME * 0.05)
		)).a,
		texture(noise, 0.625 - SCREEN_UV / 4.0 + 0.1 * vec2(
			cos(TIME * 0.05),
			sin(TIME * 0.05)
		)).a,
		0.5
	);

	vec4 color = fill_color;
	color.a *= noise_fade;
	color = mix(color, fill_color, border_fade);
	color.a *= fill_fade;

	COLOR = color;
}

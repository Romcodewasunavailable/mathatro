shader_type canvas_item;

uniform vec3 accent_color : source_color = vec3(0.25);
uniform vec3 background_color : source_color = vec3(0.0);

uniform sampler2D noise;

uniform float time_scale = 1.0;

uniform float mouse_warp_strength = 1.0;
uniform float mouse_warp_start = 0.0;
uniform float mouse_warp_end = 1024.0;

uniform float tile_size = 128.0;
uniform float grid_thickness = 4.0;
uniform float edge_blur = 1.0;

instance uniform vec2 size = vec2(40.0);
instance uniform vec2 mouse_position = vec2(0.0);

void fragment() {
	vec2 position = UV * size;
	position += (mouse_position - position) * mouse_warp_strength * smoothstep(
		mouse_warp_end,
		mouse_warp_start,
		length(mouse_position - position)
	);

	float tile_size_1 = tile_size + sin(TIME * time_scale * 0.3) * 16.0;
	vec2 tile_fade_1 = mod(
		position - mouse_position / 40.0 + vec2(
			cos(TIME * time_scale * 0.2),
			sin(TIME * time_scale * 0.25)
		) * 128.0,
		tile_size_1
	);
	vec2 grid_fade_1 = smoothstep(
		(tile_size_1 - grid_thickness) / 2.0 - edge_blur,
		(tile_size_1 - grid_thickness) / 2.0 + edge_blur,
		abs(tile_fade_1 - tile_size_1 / 2.0)
	);

	float tile_size_2 = tile_size * 1.7 + cos(TIME * time_scale * 0.175) * 8.0;
	vec2 tile_fade_2 = mod(
		position - mouse_position / 20.0 + vec2(
			sin(TIME * time_scale * 0.1),
			cos(TIME * time_scale * 0.05)
		) * 128.0,
		tile_size_2
	);
	vec2 grid_fade_2 = smoothstep(
		(tile_size_2 - grid_thickness) / 2.0 - edge_blur,
		(tile_size_2 - grid_thickness) / 2.0 + edge_blur,
		abs(tile_fade_2 - tile_size_2 / 2.0)
	);

	float noise_fade = mix(
		texture(noise, 0.25 + (position - mouse_position / 60.0) / size.x * 0.03 + vec2(
			sin(TIME * time_scale * 0.075),
			cos(TIME * time_scale * 0.03)
		) * 0.01).r,
		texture(noise, 0.25 + ((1.0 - UV) * size - mouse_position / 80.0) / size.x * 0.02 + vec2(
			sin(TIME * time_scale * 0.13),
			cos(TIME * time_scale * 0.16)
		) * 0.02).r,
		0.5
	);
	float grid_fade = max(max(grid_fade_1.x, grid_fade_1.y), max(grid_fade_2.x, grid_fade_2.y));
	float accent_fade = mix(min(grid_fade, pow(noise_fade, 4.0)), noise_fade, 0.5);

	vec3 color = mix(background_color, accent_color, accent_fade);

	COLOR = vec4(color, 1.0);
}

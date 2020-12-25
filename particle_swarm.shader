shader_type particles;

uniform sampler2D sprite;
uniform sampler2D fx_ramp;
uniform sampler2D mix_ramp;
uniform sampler2D noise_one;
uniform sampler2D noise_two;
uniform sampler2D noise_three;
uniform sampler2D noise_four;
uniform vec2 size;
uniform vec2 offset;
uniform float spacing;
uniform vec2 fx_power;
uniform vec2 fx_speed;

const float PI = 3.1416;


void vertex() {
	vec2 pos = vec2(0.0);
	pos.y = float(INDEX);
	pos.x = mod(pos.y, size.x);
	pos.y = (pos.y - pos.x) / size.x;
	
	COLOR = texture(sprite, pos / size);
	float tmp_time = (TIME - floor(TIME / LIFETIME) * LIFETIME) / LIFETIME;
	vec4 noise = vec4(texture(noise_one, pos / size).r, texture(noise_two, pos / size).r, texture(noise_three, pos / size).r, texture(noise_four, pos / size).r);
	
	pos -= vec2(size.x * 0.5 - 0.5);
	
	TRANSFORM[3].xy = pos * spacing;
	
	float anim_offset = clamp((tmp_time * 2.0 - noise.y) + noise.x * (tmp_time * 2.0 - noise.y), 0.0, 1.0);
	TRANSFORM[3].xy += vec2(offset * (sin(anim_offset * PI - PI / 2.0) / 2.0 + 0.5));
	
	float s_anim_offset = sin(anim_offset * PI);
	TRANSFORM[3].xy += vec2(cos(anim_offset * noise.w * PI * 2.0 * fx_speed.x), sin(anim_offset * noise.z * PI * 2.0 * fx_speed.y)) * fx_power * s_anim_offset;
	vec4 fx_color = texture(fx_ramp, vec2(sin(anim_offset * PI / 2.0), 0.0));
	COLOR = mix(COLOR, texture(fx_ramp, vec2(sin(anim_offset * PI / 2.0), 0.0)), texture(mix_ramp, vec2(sin(anim_offset * PI / 2.0), 0.0)));
	
	
	TRANSFORM[3].z = fract(TRANSFORM[3].y / (size.y * spacing));
}
shader_type spatial;

uniform bool active;
uniform vec3 flash_color : source_color = vec3(1.0);

uniform sampler2D sprite_texture : source_color, filter_nearest;

void fragment(){
	vec4 color = texture(sprite_texture, UV);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
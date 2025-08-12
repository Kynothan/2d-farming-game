shader_type canvas_item;

uniform float shake_intensity = 0.0;
uniform float shake_speed = 20.0;

void vertex() {
	vec2 shake = vec2(0.0);
	
	if(VERTEX.y < 0.0) {
		shake.x = sin(TIME * shake_speed + VERTEX.y) * shake_intensity;
	}
	
	VERTEX.xy += shake;
}

// Texture must have 'Filter'-flag enabled!

// Automatic smoothing
// independent of geometry and perspective
vec4 texturePointSmooth(sampler2D smp, vec2 uv, vec2 pixel_size)
{
	vec2 ddx = dFdx(uv);
	vec2 ddy = dFdy(uv);
	vec2 lxy = sqrt(ddx * ddx + ddy * ddy);
	
	vec2 uv_pixels = uv / pixel_size;
	
	vec2 uv_pixels_floor = round(uv_pixels) - vec2(0.5f);
	vec2 uv_dxy_pixels = uv_pixels - uv_pixels_floor;
	
	uv_dxy_pixels = clamp((uv_dxy_pixels - vec2(0.5f)) * pixel_size / lxy + vec2(0.5f), 0.0f, 1.0f);
	
	uv = uv_pixels_floor * pixel_size;
	
	return textureGrad(smp, uv + uv_dxy_pixels * pixel_size, ddx, ddy);
}

void fragment()
{
	COLOR = texturePointSmooth(TEXTURE, UV, TEXTURE_PIXEL_SIZE);
}
#include <metal_stdlib>
using namespace metal;

struct arguments
{
	float2 size;
	texture2d<float> glyph_cache;
};

struct sprite
{
	float2 position;
	float2 size;
	float2 texture_coordinates;
	float4 color;
};

struct rasterizer_data
{
	uint instance_id;
	float4 position [[position]];
	float4 color;
	float2 texture_coordinates;
};

constant float2 positions[] = {
        float2(0, 0),
        float2(0, 1),
        float2(1, 1),
        float2(1, 1),
        float2(1, 0),
        float2(0, 0),
};

vertex rasterizer_data
vertex_main(uint vertex_id [[vertex_id]],
        uint instance_id [[instance_id]],
        constant arguments &arguments,
        device const sprite *sprites)
{
	sprite sprite = sprites[instance_id];

	float2 position = sprite.position;
	position += sprite.size * positions[vertex_id];
	position /= arguments.size;
	position = 2 * position - 1;

	rasterizer_data output = {};
	output.instance_id = instance_id;
	output.position = float4(position, 0, 1);
	output.texture_coordinates =
	        sprite.texture_coordinates + sprite.size * positions[vertex_id];
	output.texture_coordinates.x /= arguments.glyph_cache.get_width();
	output.texture_coordinates.y /= arguments.glyph_cache.get_height();
	output.texture_coordinates.y = 1 - output.texture_coordinates.y;
	return output;
}

fragment float4
fragment_main(rasterizer_data input [[stage_in]],
        constant arguments &arguments,
        device const sprite *sprites)
{
	sprite sprite = sprites[input.instance_id];

	sampler sampler(filter::nearest, address::clamp_to_border, border_color::opaque_white);
	float sample = arguments.glyph_cache.sample(sampler, input.texture_coordinates).r;

	float4 result = sprite.color;
	result.rgb *= result.a;
	result *= sample;
	return result;
}

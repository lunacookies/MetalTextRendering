#include <metal_stdlib>
using namespace metal;

struct arguments
{
	float2 size;
};

struct sprite
{
	float2 position;
	float2 size;
};

struct rasterizer_data
{
	float4 position [[position]];
	float4 color;
};

constant float2 positions[] = {
        float2(0, 0),
        float2(0, 1),
        float2(1, 1),
        float2(1, 1),
        float2(1, 0),
        float2(0, 0),
};

constant float4 colors[] = {
        float4(0, 0, 0, 1),
        float4(0, 1, 1, 1),
        float4(1, 1, 0, 1),
        float4(1, 1, 0, 1),
        float4(1, 0, 1, 1),
        float4(0, 0, 0, 1),
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
	output.position = float4(position, 0, 1);
	output.color = colors[vertex_id];
	return output;
}

fragment float4
fragment_main(rasterizer_data input [[stage_in]])
{
	return input.color;
}

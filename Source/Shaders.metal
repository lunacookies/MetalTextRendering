#include <metal_stdlib>
using namespace metal;

struct rasterizer_data
{
	float4 position [[position]];
	float4 color;
};

constant float2 positions[] = {
        float2(-0.5, -0.5),
        float2(0, 0.5),
        float2(0.5, -0.5),
};

constant float4 colors[] = {
        float4(1, 0, 0, 1),
        float4(0, 1, 0, 1),
        float4(0, 0, 1, 1),
};

vertex rasterizer_data
vertex_main(uint vertex_id [[vertex_id]])
{
	rasterizer_data output = {};
	output.position = float4(positions[vertex_id], 0, 1);
	output.color = colors[vertex_id];
	return output;
}

fragment float4
fragment_main(rasterizer_data input [[stage_in]])
{
	return input.color;
}

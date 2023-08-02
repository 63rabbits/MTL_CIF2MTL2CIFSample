//
//  Kernel.metal
//  MTL_CIF2MTL2CIFSample
//
//  Created by 63rabbits goodman on 2023/08/02.
//

#include <metal_stdlib>
using namespace metal;

struct ShaderIO {
    float4 position [[ position ]];
    float2 texCoords;
};



vertex ShaderIO vertexThrough(constant float4 *positions  [[ buffer(0) ]],
                              constant float2 *texCoords  [[ buffer(1) ]],
                              uint            vid         [[ vertex_id ]]) {
    ShaderIO out;
    out.position = positions[vid];
    out.texCoords = texCoords[vid];
    return out;
}



fragment float4 fragmentThrough(ShaderIO          in      [[ stage_in ]],
                                texture2d<float>  texture [[ texture(0) ]]) {
    constexpr sampler colorSampler;
    return texture.sample(colorSampler, in.texCoords);
}

fragment float4 fragmentColorShift(ShaderIO           in      [[ stage_in ]],
                                   texture2d<float>   texture [[ texture(0) ]]) {
    constexpr sampler colorSampler;
    return texture.sample(colorSampler, in.texCoords).gbra;
}

fragment float4 fragmentTurnOver(ShaderIO           in      [[ stage_in ]],
                                 texture2d<float>   texture [[ texture(0) ]]) {
    constexpr sampler colorSampler;
    float x = 1.0 - in.texCoords.x;
    float y = in.texCoords.y;
    return texture.sample(colorSampler, float2(x, y));
}

constant float3 grayWeight = float3(0.298912, 0.586611, 0.114478);

fragment float4 fragmentGrayscale(ShaderIO          in      [[ stage_in ]],
                                  texture2d<float>  texture [[ texture(0) ]]) {
    constexpr sampler colorSampler;
    float4 color = texture.sample(colorSampler, in.texCoords);
    float  gray  = dot(color.rgb, grayWeight);
    return float4(gray, gray, gray, 1.0);
}

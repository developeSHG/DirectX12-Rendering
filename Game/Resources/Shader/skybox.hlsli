#ifndef _SKYBOX_HLSLI_
#define _SKYBOX_HLSLI_

#include "params.hlsli"

struct VS_IN
{
    float3 localPos : POSITION;
    float2 uv : TEXCOORD;
};

struct VS_OUT
{
    float4 pos : SV_Position;
    float2 uv : TEXCOORD;
};

VS_OUT VS_Main(VS_IN input)
{
    VS_OUT output = (VS_OUT)0;

    // Translation은 하지 않고 Rotation만 적용한다
    float4 viewPos = mul(float4(input.localPos, 0), g_matView);
    float4 clipSpacePos = mul(viewPos, g_matProjection);

    // (x y z w)
    // (x/w y/w/ z/w w/w)
    // w/w=1이기 때문에 항상 깊이가 1로 유지된다
    // z를 항상 1로 해야하기 때문에 xyww로 넣음
    output.pos = clipSpacePos.xyww;
    output.uv = input.uv;

    return output;
}

float4 PS_Main(VS_OUT input) : SV_Target
{
     float4 color = g_tex_0.Sample(g_sam_0, input.uv);
     return color;
}

#endif
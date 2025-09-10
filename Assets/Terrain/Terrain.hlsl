void GetHeightFromSDF_float
(
    float3 position,
    float height,
    UnityTexture2D sdfTex,
    float subdivision,
    out float3 outPosition,
    out float3 outNormal
)
{
    float4 uv = float4((position.xz + 1) / 2, 0, 0);
    float2 delta = float2(1 / subdivision, 0);

    float h0 = tex2Dlod(sdfTex, uv).a;
    float h1 = tex2Dlod(sdfTex, uv - delta.xyyy).a;
    float h2 = tex2Dlod(sdfTex, uv + delta.xyyy).a;
    float h3 = tex2Dlod(sdfTex, uv - delta.yxyy).a;
    float h4 = tex2Dlod(sdfTex, uv + delta.yxyy).a;

    float3 dhdx = float3(delta.x * 2, (h2 - h1) * height, 0);
    float3 dhdz = float3(0, (h4 - h3) * height, delta.x * 2);

    outPosition = position + float3(0, h0 * height, 0);
    outNormal = cross(dhdz, dhdx);
}

void GetContour_float
(
    float3 position,
    float height,
    float width1,
    float width2,
    float3 color1,
    float3 color2,
    out float3 output
)
{
    float y = position.y;
    float fw = fwidth(y);

    float h1 = height - width1 / 2 - width2;
    float h2 = height - width1 / 2;
    float h3 = height + width1 / 2;

    float p1 = smoothstep(h1 - fw, h1, y);
    float p2 = smoothstep(h2 - fw, h2, y);
    float p3 = smoothstep(h3 - fw, h3, y);

    output = lerp(color2 * p1, color1, p2) * (1 - p3);
}

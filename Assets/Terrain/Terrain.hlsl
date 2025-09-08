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
    float boldness,
    out float output
)
{
    float fw = fwidth(position.y) * boldness;
    output = smoothstep(height - fw, height, position.y) -
             smoothstep(height, height + fw, position.y);
}

void VisualizeDistance_float(float dist, out float3 color)
{
    float thresh = frac(1 - _Time.y) + 0.5;

    float rip = saturate(frac(1 - dist * 2 - _Time.y * 0.6));
    rip = rip * rip * rip * rip * saturate(dist * 100);
    rip = SRGBToLinear(0.5 * rip);

    float body = saturate((dist - 0.5) * 1000);

    color = lerp(rip * float3(0.1, 0.3, 0.8), float3(1, 1, 1), body);
}

TextureCube<float4> shadowMapPoint[1] : register(t0);
SamplerComparisonState _shadowMapPoint_sampler[1] : register(s0);
uniform float2 lightProj;
Texture2D<float4> senvmapBrdf : register(t1);
SamplerState _senvmapBrdf_sampler : register(s1);
uniform float4 shirr[7];
uniform int envmapNumMipmaps;
Texture2D<float4> senvmapRadiance : register(t2);
SamplerState _senvmapRadiance_sampler : register(s2);
uniform float envmapStrength;
uniform float3 pointPos;
uniform float3 pointCol;
uniform float pointBias;
uniform bool receiveShadow;
uniform float4 casData[20];

static float4 gl_FragCoord;
static float3 wnormal;
static float3 eyeDir;
static float3 wposition;
static float4 fragColor[2];

struct SPIRV_Cross_Input
{
    float3 eyeDir : TEXCOORD0;
    float3 wnormal : TEXCOORD1;
    float3 wposition : TEXCOORD2;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 fragColor[2] : SV_Target0;
};

float3 surfaceAlbedo(float3 baseColor, float metalness)
{
    return lerp(baseColor, 0.0f.xxx, metalness.xxx);
}

float3 surfaceF0(float3 baseColor, float metalness)
{
    return lerp(0.039999999105930328369140625f.xxx, baseColor, metalness.xxx);
}

float3 shIrradiance(float3 nor, float4 shirr_1[7])
{
    float3 cl00 = float3(shirr_1[0].x, shirr_1[0].y, shirr_1[0].z);
    float3 cl1m1 = float3(shirr_1[0].w, shirr_1[1].x, shirr_1[1].y);
    float3 cl10 = float3(shirr_1[1].z, shirr_1[1].w, shirr_1[2].x);
    float3 cl11 = float3(shirr_1[2].y, shirr_1[2].z, shirr_1[2].w);
    float3 cl2m2 = float3(shirr_1[3].x, shirr_1[3].y, shirr_1[3].z);
    float3 cl2m1 = float3(shirr_1[3].w, shirr_1[4].x, shirr_1[4].y);
    float3 cl20 = float3(shirr_1[4].z, shirr_1[4].w, shirr_1[5].x);
    float3 cl21 = float3(shirr_1[5].y, shirr_1[5].z, shirr_1[5].w);
    float3 cl22 = float3(shirr_1[6].x, shirr_1[6].y, shirr_1[6].z);
    return ((((((((((cl22 * 0.429042994976043701171875f) * ((nor.y * nor.y) - ((-nor.z) * (-nor.z)))) + (((cl20 * 0.743125021457672119140625f) * nor.x) * nor.x)) + (cl00 * 0.88622701168060302734375f)) - (cl20 * 0.2477079927921295166015625f)) + (((cl2m2 * 0.85808598995208740234375f) * nor.y) * (-nor.z))) + (((cl21 * 0.85808598995208740234375f) * nor.y) * nor.x)) + (((cl2m1 * 0.85808598995208740234375f) * (-nor.z)) * nor.x)) + ((cl11 * 1.02332794666290283203125f) * nor.y)) + ((cl1m1 * 1.02332794666290283203125f) * (-nor.z))) + ((cl10 * 1.02332794666290283203125f) * nor.x);
}

float getMipFromRoughness(float roughness, float numMipmaps)
{
    return roughness * numMipmaps;
}

float2 envMapEquirect(float3 normal)
{
    float phi = acos(normal.z);
    float theta = atan2(-normal.y, normal.x) + 3.1415927410125732421875f;
    return float2(theta / 6.283185482025146484375f, phi / 3.1415927410125732421875f);
}

float3 lambertDiffuseBRDF(float3 albedo, float nl)
{
    return albedo * max(0.0f, nl);
}

float d_ggx(float nh, float a)
{
    float a2 = a * a;
    float denom = pow(((nh * nh) * (a2 - 1.0f)) + 1.0f, 2.0f);
    return (a2 * 0.3183098733425140380859375f) / denom;
}

float v_smithschlick(float nl, float nv, float a)
{
    return 1.0f / (((nl * (1.0f - a)) + a) * ((nv * (1.0f - a)) + a));
}

float3 f_schlick(float3 f0, float vh)
{
    return f0 + ((1.0f.xxx - f0) * exp2((((-5.554729938507080078125f) * vh) - 6.9831600189208984375f) * vh));
}

float3 specularBRDF(float3 f0, float roughness, float nl, float nh, float nv, float vh)
{
    float a = roughness * roughness;
    return (f_schlick(f0, vh) * (d_ggx(nh, a) * clamp(v_smithschlick(nl, nv, a), 0.0f, 1.0f))) / 4.0f.xxx;
}

float attenuate(float dist)
{
    return 1.0f / (dist * dist);
}

float lpToDepth(inout float3 lp, float2 lightProj_1)
{
    lp = abs(lp);
    float zcomp = max(lp.x, max(lp.y, lp.z));
    zcomp = lightProj_1.x - (lightProj_1.y / zcomp);
    return (zcomp * 0.5f) + 0.5f;
}

float PCFCube(TextureCube<float4> shadowMapCube, SamplerComparisonState _shadowMapCube_sampler, float3 lp, inout float3 ml, float bias, float2 lightProj_1, float3 n)
{
    float3 param = lp;
    float _229 = lpToDepth(param, lightProj_1);
    float compare = _229 - (bias * 1.5f);
    ml += ((n * bias) * 20.0f);
    ml.y = -ml.y;
    float4 _249 = float4(ml, compare);
    float result = shadowMapCube.SampleCmp(_shadowMapCube_sampler, _249.xyz, _249.w);
    float4 _261 = float4(ml + 0.001000000047497451305389404296875f.xxx, compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _261.xyz, _261.w);
    float4 _275 = float4(ml + float3(-0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _275.xyz, _275.w);
    float4 _288 = float4(ml + float3(0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _288.xyz, _288.w);
    float4 _301 = float4(ml + float3(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _301.xyz, _301.w);
    float4 _314 = float4(ml + float3(-0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _314.xyz, _314.w);
    float4 _327 = float4(ml + float3(0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _327.xyz, _327.w);
    float4 _340 = float4(ml + float3(-0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _340.xyz, _340.w);
    float4 _353 = float4(ml + (-0.001000000047497451305389404296875f).xxx, compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _353.xyz, _353.w);
    return result / 9.0f;
}

float3 sampleLight(float3 p, float3 n, float3 v, float dotNV, float3 lp, float3 lightCol, float3 albedo, float rough, float spec, float3 f0, int index, float bias, bool receiveShadow_1)
{
    float3 ld = lp - p;
    float3 l = normalize(ld);
    float3 h = normalize(v + l);
    float dotNH = dot(n, h);
    float dotVH = dot(v, h);
    float dotNL = dot(n, l);
    float3 direct = lambertDiffuseBRDF(albedo, dotNL) + (specularBRDF(f0, rough, dotNL, dotNH, dotNV, dotVH) * spec);
    direct *= attenuate(distance(p, lp));
    direct *= lightCol;
    if (receiveShadow_1)
    {
        float3 param = -l;
        float _412 = PCFCube(shadowMapPoint[0], _shadowMapPoint_sampler[0], ld, param, bias, lightProj, n);
        direct *= _412;
    }
    return direct;
}

void frag_main()
{
    float3 n = normalize(wnormal);
    float3 vVec = normalize(eyeDir);
    float dotNV = max(dot(n, vVec), 0.0f);
    float3 basecol = float3(0.2128146588802337646484375f, 0.647005140781402587890625f, 0.80000007152557373046875f);
    float roughness = 0.5f;
    float metallic = 0.0f;
    float occlusion = 1.0f;
    float specular = 0.5f;
    float opacity = 0.2497999966144561767578125f;
    if (opacity == 1.0f)
    {
        discard;
    }
    float3 albedo = surfaceAlbedo(basecol, metallic);
    float3 f0 = surfaceF0(basecol, metallic);
    float2 envBRDF = senvmapBrdf.Sample(_senvmapBrdf_sampler, float2(roughness, 1.0f - dotNV)).xy;
    float3 indirect = shIrradiance(n, shirr);
    indirect *= albedo;
    float3 reflectionWorld = reflect(-vVec, n);
    float lod = getMipFromRoughness(roughness, float(envmapNumMipmaps));
    float3 prefilteredColor = senvmapRadiance.SampleLevel(_senvmapRadiance_sampler, envMapEquirect(reflectionWorld), lod).xyz;
    indirect += ((prefilteredColor * ((f0 * envBRDF.x) + envBRDF.y.xxx)) * 1.5f);
    indirect *= occlusion;
    indirect *= envmapStrength;
    float3 direct = 0.0f.xxx;
    int param = 0;
    float param_1 = pointBias;
    bool param_2 = receiveShadow;
    direct += sampleLight(wposition, n, vVec, dotNV, pointPos, pointCol, albedo, roughness, specular, f0, param, param_1, param_2);
    float4 premultipliedReflect = float4(float3(direct + (indirect * 0.5f)) * opacity, opacity);
    float w = clamp((pow(min(1.0f, premultipliedReflect.w * 10.0f) + 0.00999999977648258209228515625f, 3.0f) * 100000000.0f) * pow(1.0f - (gl_FragCoord.z * 0.89999997615814208984375f), 3.0f), 0.00999999977648258209228515625f, 3000.0f);
    fragColor[0] = float4(premultipliedReflect.xyz * w, premultipliedReflect.w);
    fragColor[1] = float4(premultipliedReflect.w * w, 0.0f, 0.0f, 1.0f);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    wnormal = stage_input.wnormal;
    eyeDir = stage_input.eyeDir;
    wposition = stage_input.wposition;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}

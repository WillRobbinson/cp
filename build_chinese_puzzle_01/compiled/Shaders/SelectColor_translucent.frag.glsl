#version 450
#include "compiled.inc"
#include "std/light.glsl"
#include "std/shirr.glsl"
in vec3 wnormal;
in vec3 eyeDir;
in vec3 wposition;
out vec4 fragColor[2];
uniform sampler2D senvmapBrdf;
uniform vec4 shirr[7];
uniform sampler2D senvmapRadiance;
uniform int envmapNumMipmaps;
uniform float envmapStrength;
uniform vec3 pointPos;
uniform vec3 pointCol;
uniform bool receiveShadow;
uniform float pointBias;
void main() {
	vec3 n = normalize(wnormal);
	vec3 vVec = normalize(eyeDir);
	float dotNV = max(dot(n, vVec), 0.0);
	vec3 basecol;
	float roughness;
	float metallic;
	float occlusion;
	float specular;
	float opacity;
	basecol = vec3(0.21281465888023376, 0.6470051407814026, 0.8000000715255737);
	roughness = 0.5;
	metallic = 0.0;
	occlusion = 1.0;
	specular = 0.5;
	opacity = 0.25 - 0.0002;
	if (opacity == 1.0) discard;
	vec3 albedo = surfaceAlbedo(basecol, metallic);
	vec3 f0 = surfaceF0(basecol, metallic);
	vec2 envBRDF = texture(senvmapBrdf, vec2(roughness, 1.0 - dotNV)).xy;
	vec3 indirect = shIrradiance(n, shirr);
	indirect *= albedo;
	vec3 reflectionWorld = reflect(-vVec, n);
	float lod = getMipFromRoughness(roughness, envmapNumMipmaps);
	vec3 prefilteredColor = textureLod(senvmapRadiance, envMapEquirect(reflectionWorld), lod).rgb;
	indirect += prefilteredColor * (f0 * envBRDF.x + envBRDF.y) * 1.5;
	indirect *= occlusion;
	indirect *= envmapStrength;
	vec3 direct = vec3(0.0);
	direct += sampleLight(
	  wposition, n, vVec, dotNV, pointPos, pointCol, albedo, roughness, specular, f0
	  , 0, pointBias, receiveShadow
	);	

	vec4 premultipliedReflect = vec4(vec3(direct + indirect * 0.5) * opacity, opacity);
	float w = clamp(pow(min(1.0, premultipliedReflect.a * 10.0) + 0.01, 3.0) * 1e8 * pow(1.0 - (gl_FragCoord.z) * 0.9, 3.0), 1e-2, 3e3);
	fragColor[0] = vec4(premultipliedReflect.rgb * w, premultipliedReflect.a);
	fragColor[1] = vec4(premultipliedReflect.a * w, 0.0, 0.0, 1.0);
}

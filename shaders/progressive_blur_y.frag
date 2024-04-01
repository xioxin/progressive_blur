#include <flutter/runtime_effect.glsl>
#define kernelSize 64

uniform vec2 size;

uniform float radius;
uniform float offset;
uniform float interpolation;
uniform float direction;
uniform float displayScale;
uniform float blurDirection;

uniform sampler2D image;

out vec4 fragColor;

float mapRadius(vec2 position) {
    float mapped;
    if (direction == 0.0) {
        mapped = max((position.y/size.y*displayScale-(1-offset))/interpolation, 0.0);
    } else if (direction == 1.0) {
        mapped = max(0.0-(position.y/size.y*displayScale-offset)/interpolation, 0.0);
    } else if (direction == 2.0) {
        mapped = max((position.x/size.x*displayScale-(1-offset))/interpolation, 0.0);
    } else if (direction == 3.0) {
        mapped = max(0.0-(position.x/size.x*displayScale-offset)/interpolation, 0.0);
    }
    return min(mapped*radius, radius);
}

vec4 reverseYTexture(vec2 pos) {
    return texture(image, vec2(pos.x, 1 - pos.y));
}

vec4 blurY(vec2 position) {
    float r = mapRadius(position);

    if (r == 0.0) {
        return reverseYTexture(position / size);
    }

    float weights[kernelSize];

    float sum = 0.0;

    for (int i = 0; i < kernelSize; ++i) {
        float x = float(i-(kernelSize-1)/2);
        weights[i] = exp(-(x*x)/(2.0 * r * r));
        sum+= weights[i];
    }

    for (int i = 0; i < kernelSize; ++i) {
        weights[i]/= sum;
    }

    vec4 result = vec4(0.0);
    for (int i = 0; i < kernelSize; ++i) {
        float offset = float(i-(kernelSize-1)/2);
        float y = clamp(position.y+offset, 0.0, size.y-1.0);
        result+= reverseYTexture(vec2(position.x, y) / size)*weights[i];
    }

    return result;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    fragColor = blurY(vec2(fragCoord.x, size.y - fragCoord.y));
}
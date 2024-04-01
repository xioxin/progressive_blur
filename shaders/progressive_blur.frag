#include <flutter/runtime_effect.glsl>
#define kernelSize 16
#define sqrtTwoPi 2.50662827463

//#include <impeller/gaussian.glsl>
//#include <impeller/types.glsl>

uniform vec2 size;
uniform vec2 radius;
uniform float offset;
uniform float interpolation;
uniform float direction;
uniform float displayScale;

uniform sampler2D image;

out vec4 fragColor;

vec4 reverseYTexture(vec2 pos) {
    return texture(image, vec2(pos.x, 1 - pos.y));
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 position = vec2(fragCoord.x, size.y - fragCoord.y);

    float mapped;
    if (direction == 0.0) {
        mapped = max((position.y/size.y*displayScale-(1.0-offset))/interpolation, 0.0);
    } else if (direction == 1.0) {
        mapped = max(0.0-(position.y/size.y*displayScale-offset)/interpolation, 0.0);
    } else if (direction == 2.0) {
        mapped = max((position.x/size.x*displayScale-(1.0-offset))/interpolation, 0.0);
    } else if (direction == 3.0) {
        mapped = max(0.0-(position.x/size.x*displayScale-offset)/interpolation, 0.0);
    }

    float rx = min(mapped * radius.x, radius.x);
    float ry = min(mapped * radius.y, radius.y);


//    if (rx == 0.0 && ry == 0.0) {
//        fragColor = reverseYTexture(position / size);
//    } else {
//        vec4 result = vec4(0.0);
//        float offsetX, offsetY, x, y;
//        for (int ix = -kernelSize; ix <= kernelSize; ++ix) {
//            offsetX = float(ix);
//            x = clamp(position.x + offsetX, 0.0, size.x-1.0);
//            for (int iy = -kernelSize; iy <= kernelSize; ++iy) {
//                offsetY = float(iy);
//                y = clamp(position.y + offsetY, 0.0, size.y-1.0);
//                float weightX = IPGaussianIntegral(offsetX+0.5, rx) - IPGaussianIntegral(offsetX-0.5, rx);
//                float weightY = IPGaussianIntegral(offsetY+0.5, ry) - IPGaussianIntegral(offsetY-0.5, ry);
//                result += reverseYTexture(vec2(x, y) / size) * weightX * weightY;
//            }
//        }
//        fragColor = result;
//    }

    if (rx == 0.0 && ry == 0.0) {
        fragColor = reverseYTexture( position / size);
    } else {
        float weightsX[kernelSize];
        float weightsY[kernelSize];

        float sumX = 0.0;
        float sumY = 0.0;

        for (int i = 0; i < kernelSize; ++i) {
            float x = float(i-(kernelSize-1)/2);

//            weightsX[i] = IPGaussian(x, rx);
//            weightsY[i] = IPGaussian(x, ry);

            weightsX[i] = exp(-(x*x)/(2.0 * rx * rx));
            weightsY[i] = exp(-(x*x)/(2.0 * ry * ry));

//            float varianceX = rx * rx;
//            float varianceY = ry * ry;
//            weightsX[i] = exp(-0.5 * x * x / varianceX) / (kSqrtTwoPi * rx);
//            weightsY[i] = exp(-0.5 * x * x / varianceY) / (kSqrtTwoPi * ry);

            sumX += weightsX[i];
            sumY += weightsY[i];
        }

        for (int i = 0; i < kernelSize; ++i) {
            weightsX[i] /= sumX;
            weightsY[i] /= sumY;
        }

        vec4 result = vec4(0.0);
        for (int ix = 0; ix < kernelSize; ++ix) {
            for (int iy = 0; iy < kernelSize; ++iy) {
                float offsetX = float(ix-(kernelSize-1)/2);
                float offsetY = float(iy-(kernelSize-1)/2);
                float x = clamp(position.x + offsetX, 0.0, size.x-1.0);
                float y = clamp(position.y + offsetY, 0.0, size.y-1.0);
                result += reverseYTexture( vec2(x, y) / size) * weightsX[ix] * weightsY[iy];
            }
        }
        fragColor = result;

    }
}

import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

enum ProgressiveDirection {
  up,
  down,
  right,
  left,
}

class ProgressiveBlur extends StatelessWidget {
  final Widget child;
  final double radius;
  final double offset;
  final double interpolation;
  final ProgressiveDirection direction;
  final double displayScale;

  const ProgressiveBlur({
    super.key,
    required this.child,
    this.radius = 16.0,
    this.offset = 0.0,
    this.interpolation = 0.5,
    this.direction = ProgressiveDirection.left,
    this.displayScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final directionValue =
        ProgressiveDirection.values.indexOf(direction).toDouble();
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return ShaderBuilder((BuildContext context, FragmentShader shaderX, _) {
      return ShaderBuilder((BuildContext context, FragmentShader shaderY, _) {
        return AnimatedSampler(
          (ui.Image image, Size size, Canvas canvas) {
            shaderX.setFloatUniforms((uniforms) {
              uniforms
                ..setSize(size)
                ..setFloat(radius)
                ..setFloat(offset)
                ..setFloat(interpolation)
                ..setFloat(directionValue)
                ..setFloat(displayScale);
            });
            shaderX.setImageSampler(0, image);
            final paint = Paint()..shader = shaderX;
            canvas.drawRect(Offset.zero & size, paint);
          },
          child: AnimatedSampler(
            (ui.Image image, Size size, Canvas canvas) {
              shaderY.setFloatUniforms((uniforms) {
                uniforms
                  ..setSize(size)
                  ..setFloat(radius)
                  ..setFloat(offset)
                  ..setFloat(interpolation)
                  ..setFloat(directionValue)
                  ..setFloat(displayScale);
              });
              shaderY.setImageSampler(0, image);
              final paint = Paint()..shader = shaderY;
              canvas.drawRect(Offset.zero & size, paint);
            },
            child: child,
          ),
        );
      }, assetKey: 'packages/progressive_blur/shaders/progressive_blur_y.frag');
    }, assetKey: 'packages/progressive_blur/shaders/progressive_blur_x.frag');
  }
}

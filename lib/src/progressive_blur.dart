import 'dart:ui' show Image, FragmentProgram;
import 'package:flutter/widgets.dart' hide Image;
import 'package:flutter_shaders/flutter_shaders.dart';

enum ProgressiveDirection {
  up,
  down,
  right,
  left,
}

class ProgressiveBlur extends StatelessWidget {
  static Future<FragmentProgram>? program;

  final Widget child;
  final double offset;
  final double interpolation;
  final ProgressiveDirection direction;
  final double displayScale = 1.0;
  final bool partial;
  final bool partialDebugLine;
  final double sigmaX;
  final double sigmaY;

  const ProgressiveBlur(
      {super.key,
      required this.child,
      this.sigmaX = 0.0,
      this.sigmaY = 0.0,
      this.offset = 0.0,
      this.interpolation = 0.5,
      this.direction = ProgressiveDirection.left,
      this.partial = true,
      this.partialDebugLine = false});

  draw(Image image, Size size, Canvas canvas, Shader shader) {
    final paint = Paint()..shader = shader;
    if (!partial) {
      return canvas.drawRect(Offset.zero & size, paint);
    }
    final emptyPaint = Paint();
    final offset = offsetProportion(this.offset, size);

    var blurHeight = (size.height * offset).toDouble();
    var imageBlurHeight = (image.height * offset).toDouble();
    var blurWidth = (size.width * offset).toDouble();
    var imageBlurWidth = (image.width * offset).toDouble();

    Rect src, dst;
    Offset debugLineStart, debugLineEnd;
    Rect blurRect;

    switch (direction) {
      case ProgressiveDirection.up:
        src = Rect.fromLTWH(0, imageBlurHeight, image.width.toDouble(),
            image.height.toDouble() - imageBlurHeight);
        dst =
            Rect.fromLTWH(0, blurHeight, size.width, size.height - blurHeight);
        debugLineStart = Offset(0, blurHeight);
        debugLineEnd = Offset(size.width, blurHeight);
        blurRect = Offset.zero & Size(size.width, blurHeight);
        break;
      case ProgressiveDirection.down:
        src = Rect.fromLTWH(0, 0, image.width.toDouble(),
            image.height.toDouble() - imageBlurHeight);
        dst = Rect.fromLTWH(0, 0, size.width, size.height - blurHeight);
        debugLineStart = Offset(0, size.height - blurHeight);
        debugLineEnd = Offset(size.width, size.height - blurHeight);
        blurRect =
            Rect.fromLTRB(0, size.height - blurHeight, size.width, size.height);
        break;
      case ProgressiveDirection.left:
        src = Rect.fromLTWH(imageBlurWidth, 0,
            image.width.toDouble() - imageBlurWidth, image.height.toDouble());
        dst = Rect.fromLTWH(blurWidth, 0, size.width - blurWidth, size.height);
        debugLineStart = Offset(blurWidth, 0);
        debugLineEnd = Offset(blurWidth, size.height);
        blurRect = Offset.zero & Size(blurWidth, size.height);
        break;
      case ProgressiveDirection.right:
        src = Rect.fromLTWH(0, 0, image.width.toDouble() - imageBlurWidth,
            image.height.toDouble());
        dst = Rect.fromLTWH(0, 0, size.width - blurWidth, size.height);
        debugLineStart = Offset(size.width - blurWidth, 0);
        debugLineEnd = Offset(size.width - blurWidth, size.height);
        blurRect =
            Rect.fromLTRB(size.width - blurWidth, 0, size.width, size.height);
        break;
    }

    canvas.drawImageRect(image, src, dst, emptyPaint);
    canvas.drawRect(blurRect, paint);
    if (partialDebugLine) {
      final debugLinePaint = Paint()..color = const Color(0xFFFF0000);
      canvas.drawLine(debugLineStart, debugLineEnd, debugLinePaint);
    }
  }

  offsetProportion(double offset, Size size) {
    if (direction == ProgressiveDirection.up ||
        direction == ProgressiveDirection.down) {
      return offset / size.height;
    } else {
      return offset / size.width;
    }
  }

  static Future<FragmentProgram> getProgram() {
    program ??= FragmentProgram.fromAsset(
            'packages/progressive_blur/shaders/progressive_blur_x.frag')
        .catchError((Object error, StackTrace stackTrace) {
      FlutterError.reportError(
          FlutterErrorDetails(exception: error, stack: stackTrace));
    });
    return program!;
  }

  @override
  Widget build(BuildContext context) {
    final directionValue =
        ProgressiveDirection.values.indexOf(direction).toDouble();

    //
    // return ShaderBuilder((BuildContext context, FragmentShader shaderX, _) {
    //   return ShaderBuilder((BuildContext context, FragmentShader shaderY, _) {
    //     return AnimatedSampler(
    //           (Image image, Size size, Canvas canvas) {
    //         shaderX.setFloatUniforms((uniforms) {
    //           uniforms
    //             ..setSize(size)
    //             ..setFloat(sigmaX)
    //             ..setFloat(offsetProportion(offset, size))
    //             ..setFloat(interpolation)
    //             ..setFloat(directionValue)
    //             ..setFloat(displayScale);
    //         });
    //         shaderX.setImageSampler(0, image);
    //         draw(image, size, canvas, shaderX);
    //       },
    //       child: AnimatedSampler(
    //             (Image image, Size size, Canvas canvas) {
    //           shaderY.setFloatUniforms((uniforms) {
    //             uniforms
    //               ..setSize(size)
    //               ..setFloat(sigmaY)
    //               ..setFloat(offsetProportion(offset, size))
    //               ..setFloat(interpolation)
    //               ..setFloat(directionValue)
    //               ..setFloat(displayScale);
    //           });
    //           shaderY.setImageSampler(0, image);
    //           draw(image, size, canvas, shaderY);
    //         },
    //         child: child,
    //       ),
    //     );
    //   }, assetKey: 'packages/progressive_blur/shaders/progressive_blur_y.frag');
    // }, assetKey: 'packages/progressive_blur/shaders/progressive_blur_x.frag');

    return ShaderBuilder((BuildContext context, FragmentShader shader, _) {
      return AnimatedSampler(
        (Image image, Size size, Canvas canvas) {
          shader.setFloatUniforms((uniforms) {
            uniforms
              ..setSize(size)
              ..setSize(Size(sigmaX, sigmaY))
              ..setFloat(offsetProportion(offset, size))
              ..setFloat(interpolation)
              ..setFloat(directionValue)
              ..setFloat(displayScale);
          });
          shader.setImageSampler(0, image);
          draw(image, size, canvas, shader);
        },
        child: child,
      );
    }, assetKey: 'packages/progressive_blur/shaders/progressive_blur.frag');
  }
}

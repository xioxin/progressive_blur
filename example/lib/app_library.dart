import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressive_blur/progressive_blur.dart';

class AppLibrary extends StatelessWidget {
  Widget appLogo() {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: FlutterLogo(),
            ),
          ),
        ),
      ),
    );
  }

  Widget card() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Container(
        color: Colors.white.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(flex: 1, child: appLogo()),
                    Flexible(flex: 1, child: appLogo()),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(flex: 1, child: appLogo()),
                    Flexible(flex: 1, child: appLogo()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Image.asset(
                'assets/background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
              child: ProgressiveBlur(
            direction: ProgressiveDirection.up,
            offset: 85 + padding.top,
            sigmaX: 32,
            sigmaY: 32,
            child: GridView.builder(
                padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: padding.top + 90,
                    bottom: padding.bottom),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  return card();
                }),
          )),
          Positioned(
              top: padding.top + 8,
              left: 24,
              right: 24,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: 50,
                    color: const Color(0x6FC0C0C0),
                    child: Row(
                      children: [
                        const BackButton(
                          color: Colors.white,
                        ),
                        const Spacer(),
                        Text(
                          'App Library',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 20),
                        ),
                        const Spacer(),
                        Opacity(
                          opacity: 0,
                          child: IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

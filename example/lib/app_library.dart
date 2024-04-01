import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressive_blur/progressive_blur.dart';

class AppLibrary extends StatelessWidget {
  Widget appLogo() {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlutterLogo(),
            ),
          ),
        ),
      ),
    );
  }

  Widget card() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
      child: Container(
        color: Colors.white.withOpacity(0.4),
        child: Padding(
          padding: EdgeInsets.all(8),
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
            offset: 0.18,
            radius: 40,
            child: GridView.builder(
                padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: padding.top + 90,
                    bottom: padding.bottom),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                  child: Container(
                    height: 50,
                    color: Color(0x6FC0C0C0),
                    child: Center(
                      child: Text(
                        'App Library',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

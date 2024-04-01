import 'package:flutter/material.dart';
import 'package:progressive_blur/progressive_blur.dart';

import 'app_library.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: AppLibrary()
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double radius = 20.0;
  double offset = 100;
  double interpolation = 0.5;
  ProgressiveDirection direction = ProgressiveDirection.down;

  void openAppLibrary() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AppLibrary();
    }));
  }

  item(int index) {
    return ListTile(
      leading: const FlutterLogo(),
      title: Text("LIST ITEM $index"),
      subtitle: const Text(
          'Flutter transforms the development process. Build, test, and deploy beautiful mobile, web, desktop, and embedded experiences from a single codebase.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Progressive Blur"),
      ),
      body: ProgressiveBlur(
          sigmaX: radius,
          sigmaY: radius,
          offset: offset,
          direction: direction,
          interpolation: interpolation,
          partialDebugLine: true,
          child:
              ListView.builder(itemBuilder: (context, index) => item(index))),
      floatingActionButton: FloatingActionButton(
        onPressed: openAppLibrary,
        tooltip: 'App Library',
        child: const Icon(Icons.apps),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("RADIUS", style: Theme.of(context).textTheme.labelSmall),
                const Spacer(),
                Text("${radius.toInt()}",
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            Slider(
              min: 0.0,
              max: 32.0,
              value: radius,
              onChanged: (double value) {
                setState(() {
                  radius = value;
                });
              },
            ),
            Row(
              children: [
                Text("OFFSET", style: Theme.of(context).textTheme.labelSmall),
                const Spacer(),
                Text("${offset.toInt()}",
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            Slider(
              min: 0.0,
              max: 500.0,
              value: offset,
              onChanged: (double value) {
                setState(() {
                  offset = value;
                });
              },
            ),
            Row(
              children: [
                Text("INTERPOLATION",
                    style: Theme.of(context).textTheme.labelSmall),
                const Spacer(),
                Text(interpolation.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
            Slider(
              min: 0.0,
              max: 1.0,
              value: interpolation,
              onChanged: (double value) {
                setState(() {
                  interpolation = value;
                });
              },
            ),
            Text("DIRECTIONS", style: Theme.of(context).textTheme.labelSmall),
            SegmentedButton<ProgressiveDirection>(
              segments: const [
                ButtonSegment(
                    value: ProgressiveDirection.down,
                    icon: Icon(Icons.keyboard_arrow_down)),
                ButtonSegment(
                    value: ProgressiveDirection.up,
                    icon: Icon(Icons.keyboard_arrow_up)),
                ButtonSegment(
                    value: ProgressiveDirection.left,
                    icon: Icon(Icons.keyboard_arrow_left)),
                ButtonSegment(
                    value: ProgressiveDirection.right,
                    icon: Icon(Icons.keyboard_arrow_right)),
              ],
              showSelectedIcon: false,
              selected: {direction},
              onSelectionChanged: (val) {
                setState(() {
                  direction = val.first;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

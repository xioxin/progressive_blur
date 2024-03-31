import 'package:flutter/material.dart';
import 'package:progressive_blur/progressive_blur.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  double radius = 10.0;
  double offset = 0.3;
  double interpolation = 0.5;
  ProgressiveDirection direction = ProgressiveDirection.down;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  item(int index) {
    return ListTile(
      leading: const FlutterLogo(),
      title: Text("ListItem: $index"),
      subtitle: const Text(
          'Flutter transforms the development process. Build, test, and deploy beautiful mobile, web, desktop, and embedded experiences from a single codebase.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("${widget.title} $_counter"),
      ),
      body: ProgressiveBlur(
          radius: radius,
          offset: offset,
          direction: direction,
          interpolation: interpolation,
          displayScale: 1.0,
          child:
              ListView.builder(itemBuilder: (context, index) => item(index))),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("RADIUS", style: Theme.of(context).textTheme.labelSmall),
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
            Text("OFFSET", style: Theme.of(context).textTheme.labelSmall),
            Slider(
              min: 0.0,
              max: 1.0,
              value: offset,
              onChanged: (double value) {
                setState(() {
                  offset = value;
                });
              },
            ),
            Text("INTERPOLATION",
                style: Theme.of(context).textTheme.labelSmall),
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

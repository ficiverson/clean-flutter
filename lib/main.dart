import 'package:cleanflutter/injection/dependency_injection.dart';
import 'package:cleanflutter/ui/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  Injector.configure(Flavor.PROD);
  runApp(
      new MyApp()
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      showSemanticsDebugger: false,
      checkerboardOffscreenLayers: false,
      title: 'Clean flutter',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new MyHomePage(),
//        routes: <String, WidgetBuilder>{
//          '/scanScreen': (BuildContext context) =>
//          new ScanScreen(title: 'Scan promotion'),
//        }
    );
  }
}



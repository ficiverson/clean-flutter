import 'package:cleanflutter/ui/home/home_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

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



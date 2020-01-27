import 'package:cleanflutter/injection/dependency_injection.dart';
import 'package:cleanflutter/ui/home/home_view.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

import 'injection/dependency_injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjector.configure(Flavor.PROD);
  DependencyInjector().loadModules();
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(DevicePreview(areSettingsEnabled: false,enabled: false,
    builder: (context) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        locale: DevicePreview.of(context).locale,
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        showSemanticsDebugger: false,
        checkerboardOffscreenLayers: false,
        title: 'Clean flutter',
        theme: new ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: new MyHomePage());
  }
}

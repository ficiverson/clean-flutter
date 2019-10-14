import 'dart:ui' as ui;

import "file:///Users/f.souto.gonzalez/Documents/FlutterProjects/clean_flutter/lib/main.dart" as entrypoint;

Future<void> main() async {
  if (true) {
    await ui.webOnlyInitializePlatform();
  }
  entrypoint.main();
}

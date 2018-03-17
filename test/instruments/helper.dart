import 'dart:async';
import 'dart:io';

class Helper{

  static String readFile(String path) {
    final file = new File(path);
    return file.readAsStringSync();
  }
}
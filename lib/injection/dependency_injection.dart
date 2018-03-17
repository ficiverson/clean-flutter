import 'package:flutter/services.dart';

enum Flavor {
  MOCK,
  INT,
  STAGE
}

class Injector {

  static final Injector _singleton = new Injector._internal();

  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  static Flavor getFlavor() {
    return _flavor;
  }

  static const MethodChannel eventCloseScanChannel = const MethodChannel(
      'halotex.flutter.io/scan_close');

  static const EventChannel eventChannel = const EventChannel(
      'halotex.flutter.io/scan_result');

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

}
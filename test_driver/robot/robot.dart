import 'package:flutter_driver/flutter_driver.dart';

class Robot {
  Robot(this.driver, this.work);

  final FlutterDriver driver;

  Future<void> work;

  seesKey(String key) async {
    print("sees key: $key");
    await driver.waitFor(find.byValueKey(key));
  }

  tapsOnKey(String key) async {
    print("taps on key: $key");
    await driver.tap(find.byValueKey(key));
  }

}
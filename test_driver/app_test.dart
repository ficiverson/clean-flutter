import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'robot/home_screen_robbot.dart';

void main() {
  group('home page tests', ()
  {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('can see a list of user', () async {
      var homeScreen = HomeScreenRobot(driver, Future.value(null));
      await homeScreen.seeAListOfUsers().work;
    });

    test('can see a list of user and go to next screen', () async {
      var homeScreen = HomeScreenRobot(driver, Future.value(null));
      await homeScreen.tapSecondMenuItem().work;
    });

    test('can see a custom pointer', () async {
      var homeScreen = HomeScreenRobot(driver, Future.value(null));
      await homeScreen.seeAcustomPointer().work;
    });

    test('can return to list', () async {
      var homeScreen = HomeScreenRobot(driver, Future.value(null));
      await homeScreen.tapFirstMenuItem().work;
    });

    test('can see a custom pointer and go to next screen', () async {
      var homeScreen = HomeScreenRobot(driver, Future.value(null));
      await homeScreen.tapThirdMenuItem().work;
    });

    test('can see a custom animation', () async {
      var homeScreen = HomeScreenRobot(driver, Future.value(null));
      await homeScreen.seeACustomAnimation().work;
    });

  });
}

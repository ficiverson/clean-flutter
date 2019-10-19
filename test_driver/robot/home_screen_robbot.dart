
import 'package:flutter_driver/src/driver/driver.dart';

import 'robot.dart';

class HomeScreenRobot extends Robot {
  HomeScreenRobot(FlutterDriver driver, Future<void> work) : super(driver, work);

  HomeScreenRobot seeAListOfUsers() {
    work = work.then((_) async => await seesKey("user_list"));
    return this;
  }

  HomeScreenRobot seeAcustomPointer(){
    work = work.then((_) async => await seesKey("custom_pointer"));
    return this;
  }

  HomeScreenRobot seeACustomAnimation(){
    work = work.then((_) async => await seesKey("custom_animation"));
    return this;
  }

  HomeScreenRobot tapFirstMenuItem(){
    work = work.then((_) async => await tapsOnKey("user_list_item"));
    return this;
  }

  HomeScreenRobot tapSecondMenuItem(){
    work = work.then((_) async => await tapsOnKey("custom_pointer_item"));
    return this;
  }

  HomeScreenRobot tapThirdMenuItem(){
    work = work.then((_) async => await tapsOnKey("custom_animation_item"));
    return this;
  }

}
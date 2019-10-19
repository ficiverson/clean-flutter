import 'package:cleanflutter/data/datasource/remote_user_datasource.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:cleanflutter/main.dart' as app;
import 'package:injector/injector.dart';
import 'instruments/user-remote-data-source.dart';

void main() {
  enableFlutterDriverExtension();
  app.main();
 overrideDependencies();
}

void overrideDependencies(){
  Injector.appInstance.registerDependency<UserRemoteDataSourceContract>(
          (Injector injector) {

        return new UserRemoteDataSourceInstrument();
      }, override: true);
}
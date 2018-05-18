import 'package:cleanflutter/datasource/user_datasource.dart';
import 'package:cleanflutter/repository/user_repository.dart';
import 'package:cleanflutter/ui/utils/http/client.dart';
import 'package:flutter/services.dart';

enum Flavor {
  MOCK,
  PROD,
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

  static UserRepository provideUserRepository({Client client}) {
    switch (_flavor) {
      case Flavor.MOCK:
        return new UserRepositoryImpl(
            new UserRemoteDataSource(client: client),
            provideLocalDataSource(testing: true));
      case Flavor.PROD:
        return new UserRepositoryImpl(
            new UserRemoteDataSource(), provideLocalDataSource());
      case Flavor.STAGE:
        return new UserRepositoryImpl(
            new UserRemoteDataSource(), provideLocalDataSource());
      default:
        return new UserRepositoryImpl(
            new UserRemoteDataSource(client: client),
            provideLocalDataSource(testing: true));
    }
  }

  static UserLocalDataSource provideLocalDataSource({bool testing}) {
    return new UserLocalDataSource(testing: testing);
  }

  Injector._internal();

}
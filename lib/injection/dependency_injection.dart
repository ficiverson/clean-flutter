import 'package:cleanflutter/data/datasource/user_datasource.dart';
import 'package:cleanflutter/data/repository/user_repository.dart';
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

  static const MethodChannel methodChanel = const MethodChannel(
      'clean.flutter.io/cameraResult');

  static const EventChannel eventChannel = const EventChannel(
      'clean.flutter.io/stream');

  factory Injector() {
    return _singleton;
  }

  static UserRepository provideUserRepository({Client client}) {
    switch (_flavor) {
      case Flavor.MOCK:
        return new UserRepositoryImpl(
            provideRemoteDataSource(client),
            provideLocalDataSource(testing: true));
      case Flavor.PROD:
        return new UserRepositoryImpl(
            provideRemoteDataSource(client), provideLocalDataSource());
      case Flavor.STAGE:
        return new UserRepositoryImpl(
            provideRemoteDataSource(client), provideLocalDataSource());
      default:
        return new UserRepositoryImpl(
            provideRemoteDataSource(client),
            provideLocalDataSource(testing: true));
    }
  }

  static UserLocalDataSource provideLocalDataSource({bool testing}) {
    //TODO provide a file storage or database implementation depend on flavor
    return new UserFileLocalDataSource(testing: testing);
  }

  static UserRemoteDataSourceContract provideRemoteDataSource(Client client){
    return  new UserRemoteDataSource(client: client);
  }

  Injector._internal();

}
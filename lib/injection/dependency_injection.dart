import 'package:cleanflutter/data/datasource/local_user_datasource.dart';
import 'package:cleanflutter/data/datasource/remote_user_datasource.dart';
import 'package:cleanflutter/data/repository/user_repository.dart';
import 'package:cleanflutter/data/usecase/user_use_case.dart';
import 'package:cleanflutter/ui/home/home_presenter.dart';
import 'package:cleanflutter/ui/home/home_view.dart';
import 'package:flutter/services.dart';
import 'package:injector/injector.dart';
import 'package:cleanflutter/ui/utils/http/client.dart';

enum Flavor {
  MOCK,
  PROD,
  STAGE
}

class DependencyInjector {
  get injector {
    return Injector.appInstance;
  }

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

  loadModules() {
    loadPresentationModules();
    loadDomainModules();
    loadDataModules();
    loadLocalDatasourceModules();
    loadRemoteDatasourceModules();
  }

  injectByView(dynamic view) {
    if (view is MyHomePageState) {
      injector
          .registerDependency<HomeViewContract>((Injector injector) => view);
    }
  }


  loadPresentationModules() {
    injector.registerDependency<HomePresenter>((Injector injector) {
      return new HomePresenter(
          view: injector.getDependency<HomeViewContract>(),
          fetchUsersUseCase: injector.getDependency<UserUseCase>());
    });

  }

  loadDomainModules() {
    injector.registerDependency<UserUseCase>((Injector injector) {
      var userRepository = injector.getDependency<UserRepository>();
      return UserUseCase(userRepository: userRepository);
    });
  }

  loadDataModules() {
    injector.registerDependency<UserRepository>((Injector injector) {
      var localDataSource =
      injector.getDependency<UserLocalDataSourceContract>();
      var remoteDataSource =
      injector.getDependency<UserRemoteDataSourceContract>();
      return UserRepositoryImpl(
          userRemoteDataSource: remoteDataSource,userLocalDataSource: localDataSource);
    });
  }

  loadLocalDatasourceModules() {
    //TODO provide a file storage or database implementation depend on flavor
    injector
        .registerDependency<UserLocalDataSourceContract>((Injector injector) {
      return new UserFileLocalDataSource();
    });

  }

  loadRemoteDatasourceModules() {
    injector.registerDependency<Client>((_) => Client(baseUrl: "https://randomuser.me/api/"));
    injector.registerDependency<UserRemoteDataSourceContract>(
            (Injector injector) {
              var client =
              injector.getDependency<Client>();
          return new UserRemoteDataSource(client: client);
        });
  }
}

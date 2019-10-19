import 'package:cleanflutter/data/datasource/local_user_datasource.dart';
import 'package:cleanflutter/injection/dependency_injection.dart';
import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/ui/utils/http/client.dart';
import 'package:cleanflutter/data/usecase/user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injector/injector.dart';
import 'package:mock_web_server/mock_web_server.dart';
import '../instruments/datasource/local-data_source_instrument.dart';
import '../instruments/helper.dart';


void main() {
  UserUseCase userUseCase;
  MockWebServer _server;

  setUpAll(() async {
    DependencyInjector.configure(Flavor.MOCK);
    DependencyInjector().loadModules();
    _server = new MockWebServer();
    await _server.start();
    Injector.appInstance.registerDependency<Client>((_) => Client(baseUrl: _server.url),override:true);
    Injector.appInstance.registerDependency<UserLocalDataSourceContract>((Injector injector) {
      return new UserFileLocalDataSourceInstrument();
    },override:true);
    userUseCase = Injector.appInstance.getDependency<UserUseCase>();
  });

  tearDownAll(() async {
    if (userUseCase != null) {
      userUseCase = null;
    }
    _server.shutdown();
  });


  test('that can fetch all users from network', () async {
    _server.enqueue(body: Helper.readFile("test_mocks/users.json"));
    userUseCase.params = DataPolicy.network;
    await userUseCase.execute().listen(expectAsync1((result){
      expect(result.getStatus(), equals(Status.ok));
      expect(result
          .getData()
          .length, equals(10));
    }));

  });

  test('that can store users on cache', () {
    _server.enqueue(body: Helper.readFile("test_mocks/users.json"));
    userUseCase.params = DataPolicy.network_cache;
    userUseCase.execute().listen(expectAsync1((result){
      expect(result
          .getData()
          .length, greaterThan(0));
    }));
  });

  test('that can fetch all users from cache', () {
    _server.enqueue(body: Helper.readFile("test_mocks/users.json"));
    userUseCase.params = DataPolicy.network_cache;
    userUseCase.execute().listen(expectAsync1((result){
      expect(result
          .getData()
          .length, equals(10));
    }));
  });

  test('that can handle error response from server', () {
    _server.enqueueResponse(new MockResponse()..httpCode = 404);
    userUseCase.params = DataPolicy.network;
    userUseCase.execute().listen(expectAsync1((result){
      expect(result is Error, true);
      expect(result
          .getData()
          .length, equals(0));
    }));
  });
}

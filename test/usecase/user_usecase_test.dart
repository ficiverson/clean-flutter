import 'package:cleanflutter/data/datasource/user_datasource.dart';
import 'package:cleanflutter/injection/dependency_injection.dart';
import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/ui/utils/http/client.dart';
import 'package:cleanflutter/data/usecase/user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_web_server/mock_web_server.dart';
import '../instruments/helper.dart';


void main() {
  UserUseCase userUseCase;
  UserLocalDataSource userLocalDataSource;
  MockWebServer _server;
  Client _client;

  setUpAll(() async {
    Injector.configure(Flavor.MOCK);
    _server = new MockWebServer();
    await _server.start();
    _client = new Client(baseUrl: _server.url);
    userLocalDataSource = Injector.provideLocalDataSource(testing: true);
    userUseCase =
    new UserUseCase(Injector.provideUserRepository(client: _client));
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

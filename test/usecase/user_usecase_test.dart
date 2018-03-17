import 'package:cleanflutter/datasource/user_datasource.dart';
import 'package:cleanflutter/model/result.dart';
import 'package:cleanflutter/repository/user_repository.dart';
import 'package:cleanflutter/ui/utils/http/client.dart';
import 'package:cleanflutter/usecase/user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_web_server/mock_web_server.dart';
import '../instruments/helper.dart';


void main() {
  UserUseCase userUseCase;
  UserLocalDataSource userLocalDataSource;
  UserRemoteDataSource remoteDataSource;
  MockWebServer _server;
  Client _client;

  setUpAll(() async {
    _server = new MockWebServer();
    await _server.start();
    _client = new Client(baseUrl: _server.url);
    remoteDataSource = new UserRemoteDataSource(client: _client);
    userLocalDataSource = new UserLocalDataSource(testing: true);
    userUseCase = new UserUseCase(new UserRepository(
        remoteDataSource, userLocalDataSource));
  });

  tearDownAll(() async {
    if (userUseCase != null) {
      userUseCase = null;
    }
    _server.shutdown();
  });


  test('that can fetch all users from network', () async {
    _server.enqueue(body: Helper.readFile("test_mocks/users.json"));
    var users = await userUseCase.fetchUsers(DataPolicy.network);
    expect(users.getStatus(), equals(Status.ok));
    expect(users.getData().length, equals(10));
  });

  test('that can store users on cache', () async {
    _server.enqueue(body: Helper.readFile("test_mocks/users.json"));
    var users = await userUseCase.fetchUsers(DataPolicy.network_cache);
    var users_cache = await userLocalDataSource.fetchUsers();
    expect(users.getData().length, equals(users_cache.length));
  });

  test('that can fetch all users from cache', () async {
    var users = await userUseCase.fetchUsers(DataPolicy.cache);
    expect(users.getStatus(), equals(Status.ok));
    expect(users.getData().length, equals(10));
  });

  test('that can handle error response from server', () async {
    _server.enqueueResponse(new MockResponse()..httpCode = 404);
    var users = await userUseCase.fetchUsers(DataPolicy.network);

    expect(users.getStatus(), equals(Status.fail));
    expect(users.getData().length, equals(0));
  });
}

import 'dart:async';

import 'package:cleanflutter/datasource/user_datasource.dart';
import 'package:cleanflutter/model/result.dart';
import 'package:cleanflutter/model/user.dart';

abstract class UserRepository {
  Future<Result<List<User>>> fetchUsers(DataPolicy datapolicy);

  saveUsers(List<User> users);
}

class UserRepositoryImpl implements UserRepository {
  UserRemoteDataSource userRemoteDataSource;
  UserLocalDataSource userLocalDataSource;

  UserRepositoryImpl(UserRemoteDataSource remoteDataSource,
      UserLocalDataSource userLocalDataSource) {
    this.userRemoteDataSource = remoteDataSource;
    this.userLocalDataSource = userLocalDataSource;
  }

  Future<Result<List<User>>> fetchUsers(DataPolicy datapolicy) async {
    List<User> users;
    if (datapolicy == DataPolicy.network ||
        datapolicy == DataPolicy.network_cache) {
      users = await userRemoteDataSource.fetchUsers();
    } else {
      users = await userLocalDataSource.fetchUsers();
    }

    if (users.length > 0) {
      return new Result(Status.ok, users);
    } else {
      return new Result(Status.fail, []);
    }
  }

  saveUsers(List<User> users) {
    userLocalDataSource.saveUsers(users);
  }
}
import 'dart:async';

import 'package:cleanflutter/data/datasource/user_datasource.dart';
import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/data/model/user.dart';

abstract class UserRepository {
  Future<Result<List<UserSource>>> fetchUsers(DataPolicy datapolicy);
  saveUsers(List<UserSource> users);
}

class UserRepositoryImpl implements UserRepository {
  UserRemoteDataSource userRemoteDataSource;
  UserLocalDataSource userLocalDataSource;

  UserRepositoryImpl(UserRemoteDataSource remoteDataSource,
      UserLocalDataSource userLocalDataSource) {
    this.userRemoteDataSource = remoteDataSource;
    this.userLocalDataSource = userLocalDataSource;
  }

  Future<Result<List<UserSource>>> fetchUsers(DataPolicy datapolicy) async {
    List<UserSource> users;
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

  saveUsers(List<UserSource> users) {
    userLocalDataSource.saveUsers(users);
  }
}
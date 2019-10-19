import 'dart:async';

import 'package:cleanflutter/data/datasource/local_user_datasource.dart';
import 'package:cleanflutter/data/datasource/remote_user_datasource.dart';
import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/data/model/user.dart';
import 'package:flutter/cupertino.dart';

abstract class UserRepository {
  Future<Result<List<UserSource>>> fetchUsers(DataPolicy datapolicy);
  saveUsers(List<UserSource> users);
}


class UserRepositoryImpl implements UserRepository {
  UserRemoteDataSourceContract userRemoteDataSource;
  UserLocalDataSourceContract userLocalDataSource;

  UserRepositoryImpl({@required UserRemoteDataSourceContract this.userRemoteDataSource,
    @required UserLocalDataSourceContract this.userLocalDataSource });

  Future<Result<List<UserSource>>> fetchUsers(DataPolicy datapolicy) async {
    List<UserSource> users;
    if (datapolicy == DataPolicy.network ||
        datapolicy == DataPolicy.network_cache) {
      users = await userRemoteDataSource.fetchUsers();
      if(datapolicy == DataPolicy.network_cache) {
        saveUsers(users);
      }
    } else {
      users = await userLocalDataSource.fetchUsers();
    }

    if (users.length > 0) {
      return new Success(users, Status.ok);
    } else {
      return new Error([],Status.fail, "Error fetching users");
    }
  }

  saveUsers(List<UserSource> users) {
    userLocalDataSource.saveUsers(users);
  }
}
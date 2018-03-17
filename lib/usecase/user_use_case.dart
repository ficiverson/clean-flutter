import 'dart:async';

import 'package:cleanflutter/model/result.dart';
import 'package:cleanflutter/model/user.dart';
import 'package:cleanflutter/repository/user_repository.dart';


class UserUseCase<String> {
  UserRepository userRepository;

  UserUseCase(UserRepository userRepository) {
    this.userRepository = userRepository;
  }

  Future<Result<List<User>>> fetchUsers(DataPolicy datapolicy) async {
    Result<List<User>> result = await userRepository.fetchUsers(datapolicy);
    if (result.getData().length > 0 && datapolicy == DataPolicy.network_cache) {
      userRepository.saveUsers(result.getData());
    }
    return result;
  }
}
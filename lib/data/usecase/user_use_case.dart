import 'dart:async';

import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/data/model/user.dart';
import 'package:cleanflutter/data/repository/user_repository.dart';
import 'package:cleanflutter/data/model/model_converter.dart';
import 'package:cleanflutter/ui/model/user.dart';


class UserUseCase {
  UserRepository userRepository;

  UserUseCase(UserRepository userRepository) {
    this.userRepository = userRepository;
  }

  Future<Result<List<User>>> fetchUsers(DataPolicy datapolicy) async {
    Result<List<UserSource>> result = await userRepository.fetchUsers(
        datapolicy);
    if (result.getStatus() == Status.ok &&
        result
            .getData()
            .length > 0 &&
        datapolicy == DataPolicy.network_cache) {
      userRepository.saveUsers(result.getData());
    }
    return asUIContent(result);
  }

  //convert to ui model
  Result<List<User>> asUIContent(Result<List<UserSource>> resultSource) {
    List<User> resultList = new List<User>();
    if (resultSource.getData() != null) {
      resultSource.getData().forEach((u) => resultList.add(new User(u)));
    }
    return new Result(resultSource.status, resultList);
  }
}
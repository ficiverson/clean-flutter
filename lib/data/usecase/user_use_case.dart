import 'dart:async';
import 'dart:isolate';

import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/data/model/user.dart';
import 'package:cleanflutter/data/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';

import 'base_use_case.dart';


class UserUseCase extends BaseUseCase<DataPolicy, List<UserSource>> {
  UserRepository userRepository;

  UserUseCase({@required UserRepository userRepository}) {
    this.userRepository = userRepository;
  }

  @override
  void invoke() {
    notifyListeners(userRepository.fetchUsers(params));
  }
}
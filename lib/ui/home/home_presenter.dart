import 'dart:async';

import 'package:cleanflutter/data/model/user.dart';
import 'package:cleanflutter/injection/dependency_injection.dart';
import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/data/usecase/user_use_case.dart';
import 'package:cleanflutter/ui/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injector/injector.dart';

abstract class HomeViewContract {
  onLoadUsers(List<User> users);

  onError(String msg);

  onUpdateChannel(var result);
}

class HomePresenter {
  HomeViewContract view;
  UserUseCase fetchUsersUseCase;

  MethodChannel methodChannel;
  EventChannel eventChannel;
  StreamSubscription _subscription = null;

  HomePresenter({@required this.view, @required this.fetchUsersUseCase}){
    methodChannel = DependencyInjector.methodChanel;
    eventChannel = DependencyInjector.eventChannel;
  }

  init() {
   // _enableChannel();
    fetchUsers(DataPolicy.network_cache);
  }

  void dispose() {
    _disableChannel();
  }

  onReloadData(DataPolicy policy){
    fetchUsers(policy);
  }

  /// Fetch the user data and persist when policy is storage
  ///
  /// params: datapolicy
  fetchUsers(DataPolicy datapolicy) {
    fetchUsersUseCase.params = datapolicy;
    fetchUsersUseCase.execute().listen((result) {
      if (result is Success) {
        view.onLoadUsers(_asUIContent(result).data);
      } else {
        view.onError(result.status.toString());
      }
    });
  }

  ///
  /// convert domain model to view model
  ///
  Result<List<User>> _asUIContent(Result<List<UserSource>> resultSource) {
    List<User> resultList = new List<User>();
    if (resultSource.getData() != null) {
      resultSource.getData().forEach((u) => resultList.add(new User(u)));
    }
    return new Result(resultSource.status, resultList);
  }

  /// Fetch data from native like GPS
  Future<Null> _getNativeData() async {
    try {
      final int result = await methodChannel.invokeMethod('getNativeData');
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  /// handle channel
  void _enableChannel() {
    if (_subscription == null) {
      try {
        _subscription = eventChannel.receiveBroadcastStream().listen(
            view.onUpdateChannel, cancelOnError: view.onError("error"));
      } on Exception catch (e) {
        print(e.toString());
      }
    }
  }

  void _disableChannel() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

}

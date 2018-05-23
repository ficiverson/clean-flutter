import 'dart:async';

import 'package:cleanflutter/injection/dependency_injection.dart';
import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/data/usecase/user_use_case.dart';
import 'package:cleanflutter/ui/model/user.dart';
import 'package:flutter/services.dart';

abstract class HomeViewContract {
  onLoadUsers(List<User> users);

  onError(String msg);

  onUpdateChannel(var result);
}

class HomePresenter {
  HomeViewContract _view;

  MethodChannel methodChannel;
  EventChannel eventChannel;
  StreamSubscription _subscription = null;

  HomePresenter(this._view) {
    methodChannel = Injector.methodChanel;
    eventChannel = Injector.eventChannel;
  }

  /**
   * Presenter lifecicle
   */
  void init() {
    _enableChannel();
    fetchUsers(DataPolicy.network_cache);
  }

  void dispose() {
    _disableChannel();
  }

  /**
   * Fetch the user data and persist when policy is storage
   *
   * params: datapolicy
   */
  fetchUsers(DataPolicy datapolicy) async {
    var result = await new UserUseCase(
        Injector.provideUserRepository())
        .fetchUsers(datapolicy);
    if (result.status == Status.ok) {
      _view.onLoadUsers(result.data);
    } else {
      _view.onError(result.status.toString());
    }
  }

  /**
   * Fetch data from native like GPS
   */
  Future<Null> _getNativeData() async {
    try {
      final int result = await methodChannel.invokeMethod('getNativeData');
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  /**
   * handle channel
   */
  void _enableChannel() {
    if (_subscription == null) {
      try {
        _subscription = eventChannel.receiveBroadcastStream().listen(
            _view.onUpdateChannel, cancelOnError: _view.onError("error"));
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

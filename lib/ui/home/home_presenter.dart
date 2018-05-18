import 'package:cleanflutter/injection/dependency_injection.dart';
import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/data/usecase/user_use_case.dart';
import 'package:cleanflutter/ui/model/user.dart';

abstract class HomeViewContract {
  onLoadUsers(Result<List<User>> users);
}

class HomePresenter {
  HomeViewContract _view;

  //EventChannel eventChannel;
  //MethodChannel _removePocket;

  HomePresenter(this._view) {
    fetchUsers(DataPolicy.network_cache);
  }

  /**
   * Fetch the user data and persist when policy is storage
   *
   * params: datapolicy
   */
  fetchUsers(DataPolicy datapolicy) async {
    var users = await new UserUseCase(
        Injector.provideUserRepository())
        .fetchUsers(datapolicy);
    _view.onLoadUsers(users);
  }

}

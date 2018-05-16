import 'package:cleanflutter/datasource/user_datasource.dart';
import 'package:cleanflutter/model/result.dart';
import 'package:cleanflutter/model/user.dart';
import 'package:cleanflutter/repository/user_repository.dart';
import 'package:cleanflutter/usecase/user_use_case.dart';

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
   * Fetch the user data
   *
   * params: datapolicy
   */
  fetchUsers(DataPolicy datapolicy) async {
    var users = await new UserUseCase(new UserRepository(
        new UserRemoteDataSource(), new UserLocalDataSource()))
        .fetchUsers(datapolicy);

    _view.onLoadUsers(users);
  }

}

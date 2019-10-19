import 'package:cleanflutter/data/datasource/remote_user_datasource.dart';
import 'package:cleanflutter/data/model/user.dart';
import 'package:mockito/mockito.dart';

class UserRemoteDataSourceInstrument implements UserRemoteDataSourceContract {
  @override
  Future<List<UserSource>> fetchUsers() async {
    return [MockUserSource(),MockUserSource(),MockUserSource(),MockUserSource(),MockUserSource(),MockUserSource()];
  }

}

class MockUserSource extends Mock implements UserSource {
  String picture = "https://teorico.net/images/test-dgt-1.png";
  String first = "PACO";
  String city = "LaCoru";
}
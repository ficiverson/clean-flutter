import 'package:cleanflutter/data/model/user.dart';
import 'package:cleanflutter/ui/model/user.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {
  String picture = "http://localhost:8080/test.png";
  String first = "PACO";
  String city = "LaCoru";

  @override
  User fromSourceModel(UserSource fromModel) {
    return new User(fromModel);
  }
}

class MockUserSource extends Mock implements UserSource {
  String picture = "http://localhost:8080/test.png";
  String first = "PACO";
  String city = "LaCoru";
}
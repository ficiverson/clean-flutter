import 'package:cleanflutter/data/model/user.dart';
import 'package:cleanflutter/data/model/model_converter.dart';

class User implements Convert<UserSource, User> {

  String picture;
  String first;
  String city;

  User(UserSource fromModel) {
    picture = fromModel.picture;
    first = fromModel.first;
    city = fromModel.city;
  }

  @override
  User fromSourceModel(UserSource fromModel) {
    return new User(fromModel);
  }


}
import 'package:cleanflutter/data/model/user.dart';
import 'package:cleanflutter/data/model/model_converter.dart';

class User implements Convert<UserSource, User> {

  String email;
  String picture;
  String first;
  String last;
  String street;
  String city;
  String state;
  String postcode;

  User(UserSource fromModel) {
    picture = fromModel.picture;
    first = fromModel.first;
    city = fromModel.city;
    email = fromModel.email;
    last = fromModel.last;
    street = fromModel.street;
    postcode = fromModel.postcode;
    state = fromModel.state;
  }

  @override
  User fromSourceModel(UserSource fromModel) {
    return new User(fromModel);
  }


}
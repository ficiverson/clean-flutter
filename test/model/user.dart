import 'package:cleanflutter/data/model/user.dart';
import 'package:cleanflutter/ui/home/row_view.dart';
import 'package:cleanflutter/ui/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../instruments/mocks/mock_user.dart';

void main() {
  test('can create a user', () {
    User myUser = new MockUser();
    expect(myUser.picture, "http://localhost:8080/test.png");
    expect(myUser.first, "PACO");
  });

  test('can map a model from data source', () {
    UserSource userSource = new MockUserSource();
    User myUser = new MockUser().fromSourceModel(new MockUserSource());
    expect(myUser.picture, userSource.picture);
    expect(myUser.first, userSource.first);
  });
}
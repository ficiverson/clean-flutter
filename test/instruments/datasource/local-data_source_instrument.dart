import 'dart:convert';
import 'package:cleanflutter/data/datasource/local_user_datasource.dart';
import 'package:cleanflutter/data/model/user.dart';
import 'dart:async';
import 'dart:io';

class UserFileLocalDataSourceInstrument implements UserLocalDataSourceContract {

  bool testing = false;

  UserFileLocalDataSourceInstrument({String  testing}) :
        testing = testing != null ? testing : false;

  Future<List<UserSource>> fetchUsers() async {
    var res = await _readFile();
    try {
      List<Map<String, dynamic>> items;
      items = res["results"];
      List<UserSource> users = items
          .map((r) => new UserSource.fromMap(r))
          .toList();
      return users;
    } catch (err) {
      return [];
    }
  }

  Future<Null> saveUsers(List<UserSource> users) async {
    //nothing to save its a framework problem
  }


  //helpers with files

  Future<Map> _readFile() async {
    try {
      File file = new File("test_mocks/users.json");
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      return json.decode(contents);
    } on FileSystemException {
      return json.decode("");
    }
  }
}
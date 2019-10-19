import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cleanflutter/data/model/user.dart';

/// Local data source
abstract class UserLocalDataSourceContract {
  Future<List<UserSource>> fetchUsers();

  Future<Null> saveUsers(List<UserSource> users);
}

class UserFileLocalDataSource implements UserLocalDataSourceContract {

  UserFileLocalDataSource();

  Future<List<UserSource>> fetchUsers() async {
    var res = await _readFile();
    try {
      List<Map<String, dynamic>> items;
      items = json.decode(res["results"]);
      List<UserSource> users = items
          .map((r) => new UserSource.fromMap(r))
          .toList();
      return users;
    } catch (err) {
      return [];
    }
  }

  Future<Null> saveUsers(List<UserSource> users) async {
    // write the data as a string to the file
    List<Map<String, dynamic>> userMap = new List<Map<String, dynamic>>();
    users.forEach((user) => userMap.add(user.toMap()));
    Map results = new Map();
    results["results"] = json.encode(userMap);
    await (await _getFile()).writeAsString(json.encode(results).toString());

  }


  //helpers with files

  Future<File> _getFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/users.json');
  }

  Future<Map> _readFile() async {
    try {
      File file = await _getFile();
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      return json.decode(contents);
    } on FileSystemException {
      return json.decode("");
    }
  }
}


class UserDatabaseLocalDataSource implements UserLocalDataSourceContract {
  bool testing = false;

  UserDatabaseLocalDataSource({bool testing}) :
        testing = testing != null ? testing : false;

  Future<List<UserSource>> fetchUsers() async {
    //TODO implement a database implementation to persist data
    return null;
  }

  Future<Null> saveUsers(List<UserSource> users) async {
    //TODO database implementation to persist data
    return null;
  }

}
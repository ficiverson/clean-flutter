import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cleanflutter/data/model/user.dart';
import 'package:cleanflutter/ui/utils/http/client.dart';

/**
 * Remote data source
 */
class UserRemoteDataSource {
  Client _client = new Client(baseUrl: "https://randomuser.me/api/");
  String endpoint = "?results=100";

  UserRemoteDataSource({Client client}) {
    _client = client != null ? client : _client;
  }

  Future<List<UserSource>> fetchUsers() async {
    try {
      Uri url = Uri.parse(_client.baseUrl + endpoint);
      var res = await this._client.get(url);
      List<Map<String, dynamic>> items = res["results"];
      List<UserSource> users =
          items.map((r) => new UserSource.fromMap(r)).toList();
      return users;
    } on HttpException catch (e) {
      return [];
    } catch (err) {
      return [];
    }
  }
}

/**
 * Local data source
 */
abstract class UserLocalDataSource {
  Future<List<UserSource>> fetchUsers();

  Future<Null> saveUsers(List<UserSource> users);
}

class UserFileLocalDataSource implements UserLocalDataSource {
  bool testing = false;

  UserFileLocalDataSource({bool testing})
      : testing = testing != null ? testing : false;

  Future<List<UserSource>> fetchUsers() async {
    var res = await _readFile();
    try {
      List<Map<String, dynamic>> items;
      if (testing) {
        items = res["results"];
      } else {
        items = json.decode(res["results"]);
      }
      List<UserSource> users =
          items.map((r) => new UserSource.fromMap(r)).toList();
      return users;
    } catch (err) {
      return [];
    }
  }

  Future<Null> saveUsers(List<UserSource> users) async {
    if (testing) {
      //nothing to save its a framework problem

    } else {
      // write the data as a string to the file
      List<Map<String, dynamic>> userMap = new List<Map<String, dynamic>>();
      users.forEach((user) => userMap.add(user.toMap()));
      Map results = new Map();
      results["results"] = json.encode(userMap);
      await (await _getFile()).writeAsString(json.encode(results).toString());
    }
  }

  //helpers with files

  Future<File> _getFile() async {
    if (testing) {
      return await new File("test_mocks/users.json");
    } else {
      // get the path to the document directory.
      String dir = (await getApplicationDocumentsDirectory()).path;
      return new File('$dir/users.json');
    }
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

class UserDatabaseLocalDataSource implements UserLocalDataSource {
  bool testing = false;

  UserDatabaseLocalDataSource({bool testing})
      : testing = testing != null ? testing : false;

  Future<List<UserSource>> fetchUsers() async {
    //TODO implement a database implementation to persist data
    return null;
  }

  Future<Null> saveUsers(List<UserSource> users) async {
    //TODO database implementation to persist data
    return null;
  }
}

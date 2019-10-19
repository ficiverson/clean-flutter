import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cleanflutter/data/model/user.dart';
import 'package:cleanflutter/ui/utils/http/client.dart';

/// Remote data source
abstract class UserRemoteDataSourceContract {
  Future<List<UserSource>> fetchUsers();
}
class UserRemoteDataSource implements UserRemoteDataSourceContract {
  Client client;
  String endpoint = "?results=100";

  UserRemoteDataSource({@required Client this.client});

  Future<List<UserSource>> fetchUsers() async {
    try {
      Uri url = Uri.parse(client.baseUrl + endpoint);
      var res = await this.client.get(url);
      List<dynamic> items = res["results"];
      List<UserSource> users = items
          .map((r) => new UserSource.fromMap(r))
          .toList();

      return users;
    } on HttpException catch (e) {
      return [];
    } catch (err) {
      return [];
    }
  }
}
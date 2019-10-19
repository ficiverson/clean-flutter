import 'dart:async';

import 'package:cleanflutter/ui/utils/http/simple_client.dart';
import 'package:flutter/cupertino.dart';

class Client extends SimpleClient {
  String baseUrl;

  Client({@required String baseUrl}) :
        this.baseUrl = baseUrl;

  @override
  Future sendRequest (SimpleRequest request) {
    return super.sendRequest(request);
  }

}

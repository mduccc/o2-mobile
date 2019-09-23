import 'dart:convert';

import 'package:o2_mobile/business/EndPoint.dart';
import 'package:o2_mobile/models/AccModel.dart';
import 'package:o2_mobile/models/LoginModel.dart';
import 'package:http/http.dart' as http;

class LoginProvider {
  http.Client _client = http.Client();

  Future<LoginModel> valid(String username, String password) async {
    try {
      http.Response response = await this._client.post(EndPoint.login,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({'username': username, 'password': password}));
      return LoginModel.fromJson(json.decode(response.body));
    } catch (exeption) {
      print(exeption);
      return null;
    }
  }

  Future<AccModel> info(String token) async {
    try {
      http.Response response = await this._client.post(EndPoint.accinfo,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({'token': token}));
      return AccModel.fromJson(json.decode(response.body));
    } catch (exeption) {
      print(exeption);
      return null;
    }
  }
}

final loginProvider = LoginProvider();

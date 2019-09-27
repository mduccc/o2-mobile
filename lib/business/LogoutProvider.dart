import 'dart:convert';

import 'package:o2_mobile/business/EndPoint.dart';
import 'package:o2_mobile/models/DeviceModel.dart';
import 'package:http/http.dart' as http;

import 'DatabaseProvider.dart';

class LogoutProvider {
  http.Client _client = http.Client();
  // Because struct of Logout response and Switch response is same
  Future<Switch> logout() async {
    try {
      await databaseProvider.openOrCreate();
      http.Response response = await this._client.post(EndPoint.logout,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({'token': await databaseProvider.getToken()}));
      return Switch.fromJson(json.decode(response.body));
    } catch (err) {
      print(err);
      return null;
    }
  }
}

final logoutProvider = LogoutProvider();

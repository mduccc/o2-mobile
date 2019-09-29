import 'dart:convert';

import 'package:o2_mobile/business/EndPoint.dart';
import 'package:http/http.dart' as http;
import 'package:o2_mobile/models/DeviceModel.dart';

import 'DatabaseProvider.dart';

class DeviceControlProvider {
  http.Client _client = http.Client();

  Future<State> state() async {
    try {
      await databaseProvider.openOrCreate();

      http.Response response = await this._client.post(EndPoint.deviceState,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({'token': await databaseProvider.getToken()}));
      return State.fromJson(json.decode(response.body));
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<Switch> switch_(String device_name, String _switch) async {
    try {
      await databaseProvider.openOrCreate();

      http.Response response = await this._client.post(EndPoint.deviceSwitch,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'token': await databaseProvider.getToken(),
            'device_name': device_name,
            'switch': _switch
          }));
      return Switch.fromJson(json.decode(response.body));
    } catch (err) {
      print(err);
      return null;
    }
  }
}

final deviceControlProvider = DeviceControlProvider();

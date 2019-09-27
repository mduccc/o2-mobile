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

      http.Response response = await this._client.post(EndPoint.sensorState,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({'token': databaseProvider.getToken()}));
      return State.fromJson(json.decode(response.body));
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<Switch> _switch(String sensor_name, String _switch) async {
    try {
      await databaseProvider.openOrCreate();

      http.Response response = await this._client.post(EndPoint.sensorSwitch,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode(
              {'token': databaseProvider.getToken(), 'sensor_name': _switch}));
      return Switch.fromJson(json.decode(response.body));
    } catch (err) {
      print(err);
      return null;
    }
  }
}

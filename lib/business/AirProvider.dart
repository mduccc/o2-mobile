import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:o2_mobile/business/DatabaseProvider.dart';
import 'package:o2_mobile/business/EndPoint.dart';
import 'package:o2_mobile/models/AirModel.dart';

class AirProvider {
  http.Client _client = http.Client();

  //Load current
  Future<AirModel> loadAirCurrent() async {
    await databaseProvider.openOrCreate();
    try {
      print('loadAirCurrent');
      http.Response response = await this._client.post(EndPoint.airDataCurrent,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({'token': await databaseProvider.getToken()}));

      return AirModel.fromJson(json.decode(response.body));
    } catch (err) {
      print(err);
      return null;
    }
  }

  // Just load on current day
  Future<AirModel> loadAirToday() async {
    await databaseProvider.openOrCreate();
    try {
      print('loadAirToday');
      var now = DateTime.now();
      var d = now.day < 10 ? '0' + now.day.toString() : now.day.toString();
      var m =
          now.month < 10 ? '0' + now.month.toString() : now.month.toString();
      var y = now.year.toString();

      String date = d + '-' + m + '-' + y;
      print(date);

      http.Response response = await this._client.post(EndPoint.airData,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode(
              {'token': await databaseProvider.getToken(), 'date': date}));

      return AirModel.fromJson(json.decode(response.body));
    } catch (err) {
      print(err);
      return null;
    }
  }
}

final airProvider = AirProvider();

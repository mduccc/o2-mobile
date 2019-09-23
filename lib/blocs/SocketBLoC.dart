import 'dart:convert';

import 'package:o2_mobile/blocs/AirBloC.dart';
import 'package:o2_mobile/business/DatabaseProvider.dart';
import 'package:o2_mobile/business/EndPoint.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketBLoC {
  IO.Socket _socket = null;
  String token = null;

  Future connect() async {
    await databaseProvider.openOrCreate();
    this.token = await databaseProvider.getToken();
    if (this.token != null)
      this._socket = IO.io(EndPoint.domain, <String, dynamic>{
        'transports': ['websocket'],
        'query': {'token': this.token}
      });
  }

  onConnect() {
    print('Connecting to socket');
    this._socket.on('connect', (_) {
      print('Connected to socket');
    });
  }

  onNotify() {
    this._socket.on('notify', (message) {
      print(message);
    });
  }

  Future onDataChange(String place_id) async {
    print('place_id: ' + place_id);
    this._socket.on(place_id, (data) {
      print('onDataChange');
      // var _jsonEncode = json.encode(data);
      // var _jsonDecode = json.decode(_jsonEncode);
      // AirModel airModel = AirModel.fromJson(_jsonDecode);
      // print('message: ' + airModel.message);
      // airTodayStream.add(airModel);
      airBloC.loadAirToday();
      airBloC.loadAirCurrent();
    });
  }
}

final socketBLoC = SocketBLoC();

import 'dart:convert';

import 'package:o2_mobile/blocs/AirBloC.dart';
import 'package:o2_mobile/business/DatabaseProvider.dart';
import 'package:o2_mobile/business/EndPoint.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketBLoC {
  IO.Socket socket = IO.io(EndPoint.domain, <String, dynamic>{
    'transports': ['websocket']
  });
  connect() {
    print('Connecting to socket');
    this.socket.on('connect', (_) {
      print('Connected to socket');
    });
  }

  onNotify() async {
    await databaseProvider.openOrCreate();
    String token = await databaseProvider.getToken();
    this.socket.on('notify', (message) {
      print(message);
      print(token);
      airBloC.loadAirCurrent();
      airBloC.loadAirToday();
    });
  }

  onDataChange() async {
    await databaseProvider.openOrCreate();
    String token = await databaseProvider.getToken();
    this.socket.on(token, (data) {
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

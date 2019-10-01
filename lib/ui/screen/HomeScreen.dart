import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:o2_mobile/blocs/AirBloC.dart';
import 'package:o2_mobile/blocs/LoginBloC.dart';
import 'package:o2_mobile/blocs/SocketBLoC.dart';
import 'package:o2_mobile/business/LoginProvider.dart';
import 'package:o2_mobile/models/ChartModel.dart';
import 'package:o2_mobile/ui/ThemseColors.dart';
import 'package:o2_mobile/ui/fragment/AQICurrent.dart';
import 'package:o2_mobile/ui/fragment/BottomSheet.dart' as custom;
import 'package:o2_mobile/ui/fragment/Chart.dart';
import 'package:o2_mobile/ui/fragment/HomeHeader.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomeScreenState();
  }
}

class _MyHomeScreenState extends State<HomeScreen> {
  final _channel = BasicMessageChannel<String>('cross', StringCodec());
  final _serviceBackgroudChannel =
      BasicMessageChannel<dynamic>('backgroundService', JSONMessageCodec());
  double _height;
  double _width;
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Load and add data to stream, stream have a listener every data set changed
    airBloC.loadAirToday();
    airBloC.loadAirCurrent();

    // Registe to socket
    socketBLoC.connect().then((_) async {
      socketBLoC.onConnect();
      socketBLoC.onNotify();
      if (socketBLoC.token != null) {
        loginProvider.info(socketBLoC.token).then((_) {
          if (_ != null && _.code == 200) {
            socketBLoC.onDataChange(_.place_id);
            accInfoPublishSubject.add(_);
          }
        });
      }

      // For Android
      if (Platform.isAndroid) {
        // Try call function from Kotlin
        String reply = await this._channel.send('Sent from Dart');
        print(reply);
        // Try call function from Kotlin with Json
        await this
            ._serviceBackgroudChannel
            .send(json.encode({'title': 'Hello', 'content': 'Hello you'}));
      }

      // For IOS
      if (Platform.isIOS) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    this._height = MediaQuery.of(context).size.height;
    this._width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Builder(
      key: this._scaffoldKey,
      builder: (BuildContext context) {
        // Parent
        return Container(
          color: ThemseColors.primaryColor,
          // Widget over on others Widget
          child: Stack(
            children: <Widget>[
              // Chart content
              Container(
                width: this._width,
                height: this._height / 2,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: HomeHeader(),
                    ),
                    // Chart
                    Expanded(
                        flex: 4,
                        child: Container(
                            width: this._width,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            margin: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: ThemseColors.secondColor,
                            ),
                            child: ChartFrag(
                                ChartModel.aqi, this._width, this._height))),
                    // AOI current
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: AQICurrent(),
                        ))
                  ],
                ),
              ),
              // Bottom Sheet content
              custom.BottomSheet(this._width, this._height)
            ],
          ),
        );
      },
    ));
  }
}

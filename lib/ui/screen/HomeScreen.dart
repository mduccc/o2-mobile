import 'package:flutter/material.dart';
import 'package:o2_mobile/blocs/AirBloC.dart';
import 'package:o2_mobile/blocs/SocketBLoC.dart';
import 'package:o2_mobile/business/DatabaseProvider.dart';
import 'package:o2_mobile/models/ChartModel.dart';
import 'package:o2_mobile/ui/ThemseColors.dart';
import 'package:o2_mobile/ui/fragment/AQICurrent.dart';
import 'package:o2_mobile/ui/fragment/BottomSheet.dart' as custom;
import 'package:o2_mobile/ui/fragment/Chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomeScreenState();
  }
}

class _MyHomeScreenState extends State<HomeScreen> {
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
    socketBLoC.connect();
    socketBLoC.onDataChange();
    socketBLoC.onNotify();

    print('initState');
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
          color: ThemseColors.primariColor,
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
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        margin: MediaQuery.of(context).padding,
                        child: Align(
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            'AQI Live:',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    // Chart
                    Expanded(
                        flex: 4,
                        child: Container(
                            width: this._width,
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 20),
                            child: ChartFrag(ChartModel.aqi))),
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

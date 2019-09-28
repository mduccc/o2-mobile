import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:o2_mobile/blocs/AirStream.dart';
import 'package:o2_mobile/business/Thresholds.dart';
import 'package:o2_mobile/business/Validate.dart';
import 'package:o2_mobile/models/AirModel.dart';
import 'package:o2_mobile/ui/ThemseColors.dart';

class AQICurrent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AQICurrentState();
  }
}

class _AQICurrentState extends State<AQICurrent> {
  Widget _AQICurrent(String value) {
    var aqiValue = '-';
    var aqiQuality = '-';
    if (value != null) {
      aqiValue = value;
      aqiQuality = Thresholds.aqi(double.parse(aqiValue));
    }

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
          color: ThemseColors.secondColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Value
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: FractionalOffset.bottomCenter,
                      child: Text('AQI Current',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ),
                  // Quality
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: FractionalOffset.topCenter,
                      child: Text(aqiQuality,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 12)),
                    ),
                  )
                ],
              )),
          Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  aqiValue,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: airCurrentStream.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasError) {
          if (snapshot.hasData) {
            AirModel airModel = snapshot.data;
            var dust =
                Validate.isDouble(airModel.places[0].times[0].datas.dust);
            if (dust != false) {
              double aqi = 0;
              dust > 36.455
                  ? aqi = ((dust / 1024) - 0.0356) * 120000 * 0.035
                  : aqi = 0;
              print('AQI current: ' + aqi.toString());

              return _AQICurrent(aqi.toStringAsFixed(0));
            }
          }
        }
        return _AQICurrent(null);
      },
    );
  }
}

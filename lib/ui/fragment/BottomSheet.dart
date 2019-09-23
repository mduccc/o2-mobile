import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:o2_mobile/blocs/AirStream.dart';
import 'package:o2_mobile/business/HTML.dart';
import 'package:o2_mobile/business/Validate.dart';
import 'package:o2_mobile/models/AirModel.dart';
import 'package:o2_mobile/ui/ThemseColors.dart';
import 'package:o2_mobile/business/Thresholds.dart';

class BottomSheet extends StatefulWidget {
  double _width, _height;
  BottomSheet(this._width, this._height);
  @override
  State<StatefulWidget> createState() {
    return BottomSheetState(this._width, this._height);
  }
}

class BottomSheetState extends State<BottomSheet> {
  double _width, _height;
  BottomSheetState(this._width, this._height);

  Widget _airItem(String airName, String airQuality, String airValue,
      String airUnit, Color bgColor, textColors) {
    return Container(
      width: this._width,
      height: 55,
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: <Widget>[
          // Name, infor
          Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          airName,
                          style: TextStyle(
                              color: textColors,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          airQuality,
                          style: TextStyle(
                              color: textColors,
                              fontSize: 11,
                              fontWeight: FontWeight.w300),
                        ),
                      )),
                    ),
                  ],
                ),
              )),
          // Value
          Expanded(
            flex: 1,
            child: Container(
                child: Row(
              children: <Widget>[
                // Vallue
                Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: FractionalOffset.centerRight,
                      child: Text(
                        airValue,
                        style: TextStyle(
                            color: textColors,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    )),
                // Unit
                Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: FractionalOffset.centerLeft,
                      child: Text(
                        ' ' + airUnit,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w200),
                      ),
                    ))
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _listAir(AirModel airModel) {
    String dust = '-';
    String co = '-';
    String uv = '-';
    String temp = '-';
    String humidity = '-';

    String dustQuality = '-';
    String coQuality = '-';
    String uvQuality = '-';
    String tempQuality = '-';
    String humidityQuality = '-';

    if (airModel != null) {
      dust =
          Validate.isDoubleAndToString(airModel.places[0].times[0].datas.dust)
              .toString();
      co = Validate.isDoubleAndToString(airModel.places[0].times[0].datas.co)
          .toString();
      uv = Validate.isDoubleAndToString(airModel.places[0].times[0].datas.uv)
          .toString();
      temp =
          Validate.isDoubleAndToString(airModel.places[0].times[0].datas.temp)
              .toString();
      humidity = Validate.isDoubleAndToString(
              airModel.places[0].times[0].datas.humidity)
          .toString();

      dust != 'false' ? dust = dust : dust = '-';
      co != 'false' ? co = co : co = '-';
      uv != 'false' ? uv = uv : uv = '-';
      temp != 'false' ? temp = temp : temp = '-';
      humidity != 'false' ? humidity = humidity : humidity = '-';

      uv != 'false'
          ? uvQuality = Thresholds.uv(double.parse(uv))
          : uvQuality = uvQuality;
      temp != 'false'
          ? tempQuality = Thresholds.temp(double.parse(temp))
          : tempQuality = tempQuality;
    }
    return Column(
      children: <Widget>[
        Align(
            alignment: FractionalOffset.centerLeft,
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Text(
                'Air Current: ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        // Dust
        _airItem('Dust', dustQuality, dust, 'mg/m' + HTML.decode('&#179;'),
            Colors.blueAccent, Colors.white),
        // CO2
        _airItem('CO', coQuality, co, 'g/mol', Colors.green, Colors.white),
        // UV
        _airItem('UV', uvQuality, uv, 'mW/cm' + HTML.decode('&#178;'),
            Colors.lightBlueAccent, Colors.white),
        // Temp
        _airItem('Temperature', tempQuality, temp, HTML.decode('&#176;') + 'C',
            Colors.blue, Colors.white),
        // Humidity
        _airItem('Humidity', humidityQuality, humidity, '%',
            Colors.deepPurpleAccent, Colors.white)
      ],
    );
  }

  Widget _happenAir(AirModel airModel) {
    String rain = '-';
    String gas = '-';
    String fire = '-';

    if (airModel != null) {
      if (airModel.places[0].times[0].datas.rain == '1')
        rain = 'yes';
      else
        rain = 'no';

      if (airModel.places[0].times[0].datas.gas == '1')
        gas = 'yes';
      else
        gas = 'no';

      if (airModel.places[0].times[0].datas.fire == '1')
        fire = 'yes';
      else
        fire = 'no';
    }
    return Column(
      children: <Widget>[
        Align(
            alignment: FractionalOffset.centerLeft,
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Text(
                'Happen:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(children: <Widget>[
            // Rain
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.deepPurple),
                child: Center(
                    child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Rain: ' + rain,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 2.5, right: 2.5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.deepPurple),
                child: Center(
                    child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Gas: ' + gas,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.deepPurple),
                child: Center(
                    child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Fire: ' + fire,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
              ),
            ),
          ]),
        )
      ],
    );
  }

  Widget _bottomSheetContent(AirModel airModel) {
    return Column(
      children: <Widget>[
        _happenAir(airModel),
        _listAir(airModel),
      ],
    );
  }

  Widget _showDraggableScrollableSheet() {
    return DraggableScrollableSheet(
      minChildSize: 0.5,
      maxChildSize: 0.95,
      initialChildSize: 0.5,
      builder: (BuildContext context, ScrollController scrollController) {
        // Parent
        return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            decoration: BoxDecoration(
                color: ThemseColors.secondColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              // Content by Column
              child: Column(
                children: <Widget>[
                  Container(
                    width: this._width / 6,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                  StreamBuilder(
                    stream: airCurrentStream.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasError) {
                        if (snapshot.hasData) {
                          AirModel airModel = snapshot.data;
                          return _bottomSheetContent(airModel);
                        } else
                          print('No air current data');
                      }
                      return _bottomSheetContent(null);
                    },
                  )
                ],
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _showDraggableScrollableSheet();
  }
}

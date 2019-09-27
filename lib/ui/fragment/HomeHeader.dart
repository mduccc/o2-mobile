import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:o2_mobile/blocs/AirStream.dart';
import 'package:o2_mobile/models/AirModel.dart';

class HomeHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeHeaderState();
  }
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 10),
            margin: MediaQuery.of(context).padding,
            child: Align(
              alignment: FractionalOffset.centerLeft,
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: StreamBuilder(
                    stream: airCurrentStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasError) {
                        if (snapshot.hasData) {
                          AirModel airModel = snapshot.data;
                          if (airModel.code == 200)
                            return Text(
                              'AQI in ' + airModel.places[0].place_name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            );

                          return Text('-');
                        }
                      }
                      return Text('-');
                    },
                  )),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(right: 10),
            margin: MediaQuery.of(context).padding,
            child: Align(
                alignment: FractionalOffset.centerRight,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ))),
          ),
        )
      ],
    );
  }
}

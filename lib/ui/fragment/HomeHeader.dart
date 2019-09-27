import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:o2_mobile/blocs/AirStream.dart';
import 'package:o2_mobile/blocs/LoginBloC.dart';
import 'package:o2_mobile/models/AccModel.dart';
import 'package:o2_mobile/models/AirModel.dart';
import 'package:o2_mobile/ui/screen/ProfileScreen.dart';

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
                    stream: accInfoPublishSubject.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasError) {
                        if (snapshot.hasData) {
                          AccModel accModel = snapshot.data;
                          if (accModel.code == 200)
                            return Text(
                              'AQI in ' + accModel.place_name,
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
                    child: InkWell(
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()));
                      },
                    ))),
          ),
        )
      ],
    );
  }
}

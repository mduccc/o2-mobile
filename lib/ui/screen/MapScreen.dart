import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:o2_mobile/blocs/LoginBloC.dart';
import 'package:o2_mobile/models/AccModel.dart';

import '../ThemseColors.dart';

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapScreen();
  }
}

class _MapScreen extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    loginBloC.info();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemseColors.primaryColor,
          elevation: 0,
          title: Text(''),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: ThemseColors.primaryColor,
        body: Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
              color: ThemseColors.secondColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: accInfoPublishSubject.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasError) {
                    if (snapshot.hasData) {
                      AccModel accModel = snapshot.data;
                      if (accModel.code == 200) {
                        return Align(
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            accModel.place_name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            '-',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    }
                  }
                  return Align(
                    alignment: FractionalOffset.centerLeft,
                    child: Text(
                      '-',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}

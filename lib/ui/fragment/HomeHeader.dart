import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:o2_mobile/blocs/LoginBloC.dart';
import 'package:o2_mobile/models/AccModel.dart';
import 'package:o2_mobile/ui/screen/MapScreen.dart';
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
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: MediaQuery.of(context).padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
              alignment: FractionalOffset.center,
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: InkWell(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapScreen()));
                    },
                  ))),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.only(left: 10),
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
                              return InkWell(
                                child: Text(
                                  'Tại ' + accModel.place_name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapScreen()));
                                },
                              );

                            return Text('');
                          }
                        }
                        return Text('');
                      },
                    )),
              ),
            ),
          ),
          Align(
              alignment: FractionalOffset.center,
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
        ],
      ),
    );
  }
}

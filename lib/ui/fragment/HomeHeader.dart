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
  String _cacheName = '';

  Widget _title() {
    return InkWell(
      child: Text(
        this._cacheName,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapScreen()));
      },
    );
  }

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
                            if (accModel.code == 200) {
                              this._cacheName = accModel.place_name;
                              return _title();
                            }

                            return _title();
                          }
                        }
                        return _title();
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

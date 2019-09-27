import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:o2_mobile/blocs/LoginBloC.dart';
import 'package:o2_mobile/business/DatabaseProvider.dart';
import 'package:o2_mobile/business/LogoutProvider.dart';
import 'package:o2_mobile/models/AccModel.dart';
import 'package:o2_mobile/models/DeviceModel.dart' as prefix0;
import 'package:o2_mobile/ui/ThemseColors.dart';
import 'package:o2_mobile/ui/screen/LoginScreen.dart';
import 'package:toast/toast.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _onLogout = false;

  notify(String message, Color bgColor) {
    if (message != null && bgColor != null)
      Toast.show(message, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: bgColor);
  }

  Widget _item(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 5, top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Text(label + ':',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                )),
          ),
        ],
      ),
    );
  }

  Widget _accountHeader() {
    return Container(
      height: 70,
      margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
      decoration: BoxDecoration(
          color: ThemseColors.secondColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: <Widget>[
          // Image
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(5),
              height: double.infinity,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(Icons.account_circle, color: Colors.white),
              ),
            ),
          ),
          // Username
          Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: StreamBuilder(
                              stream: accInfoPublishSubject.stream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasError) {
                                  if (snapshot.hasData) {
                                    AccModel accModel = snapshot.data;
                                    return Text(
                                      accModel.accID,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    );
                                  }
                                }
                                return Text(
                                  '-',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                );
                              })),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _info() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: ThemseColors.secondColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: StreamBuilder(
            stream: accInfoPublishSubject.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasError) {
                if (snapshot.hasData) {
                  AccModel accModel = snapshot.data;
                  return Column(
                    children: <Widget>[
                      this._item('Email', accModel.email),
                      this._item('Place', accModel.place_name),
                    ],
                  );
                }
              }
              return Column(
                children: <Widget>[
                  this._item('Email', '-'),
                  this._item('Place', '-'),
                ],
              );
            }));
  }

  Widget _logout() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: ThemseColors.secondColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
          margin: EdgeInsets.only(bottom: 5, top: 5),
          child: Center(
            child: Container(
                child: InkWell(
              child: Text('Logout',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () async {
                setState(() {
                  this._onLogout = true;
                });
                prefix0.Switch _switch = await logoutProvider.logout();
                if (_switch != null && _switch.code == 200) {
                  await databaseProvider.openOrCreate();
                  await databaseProvider.makeEmptyTokenTable();
                  // Push and remove all others screen in router
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);

                  notify('Logged out', Colors.green);
                } else {
                  setState(() {
                    this._onLogout = false;
                  });
                }
              },
            )),
          )),
    );
  }

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
      body: Container(
          color: ThemseColors.primaryColor,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Acc header
                    this._accountHeader(),
                    // info
                    this._info(),
                    // Logout
                    this._logout()
                  ],
                ),
              ),
              Center(
                child: this._onLogout
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: ThemseColors.primaryColor.withOpacity(0.6),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Center(),
              )
            ],
          )),
    );
  }
}

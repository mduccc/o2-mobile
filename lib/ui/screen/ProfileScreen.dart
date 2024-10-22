import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:o2_mobile/blocs/LoginBloC.dart';
import 'package:o2_mobile/business/Channel.dart';
import 'package:o2_mobile/business/DatabaseProvider.dart';
import 'package:o2_mobile/business/LogoutProvider.dart';
import 'package:o2_mobile/models/AccModel.dart';
import 'package:o2_mobile/models/DeviceModel.dart' as prefix0;
import 'package:o2_mobile/ui/ThemseColors.dart';
import 'package:o2_mobile/ui/screen/DeviceScreen.dart';
import 'package:o2_mobile/ui/screen/LoginScreen.dart';
import 'package:toast/toast.dart';
import 'dart:io' show Platform;

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _onLogout = false;
  AccModel _accModel = null;

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
          Container(
              margin: EdgeInsets.only(right: 10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: FractionalOffset.centerLeft,
                child: Text(label + ':',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              )),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: FractionalOffset.centerLeft,
            child: Text(value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                )),
          )
        ],
      ),
    );
  }

  Widget _accountHeader() {
    return Container(
      height: 150,
      width: double.infinity,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
      decoration: BoxDecoration(
          color: ThemseColors.secondColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: <Widget>[
          // Image
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(5),
              height: double.infinity,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(Icons.account_circle, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: StreamBuilder(
                  stream: accInfoPublishSubject.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasError) {
                      if (snapshot.hasData) {
                        this._accModel = snapshot.data;
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: FractionalOffset.center,
                          child: Text(
                            this._accModel.accID,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                    }
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: FractionalOffset.center,
                      child: Text(
                        '-',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _info() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: ThemseColors.secondColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: StreamBuilder(
            stream: accInfoPublishSubject.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasError) {
                if (snapshot.hasData) {
                  this._accModel = snapshot.data;
                  return Column(
                    children: <Widget>[
                      this._item('Email', this._accModel.email),
                      this._item('Địa điểm', this._accModel.place_name),
                    ],
                  );
                }
              }
              return Column(
                children: <Widget>[
                  this._item('Email', '-'),
                  this._item('Địa điểm', '-'),
                ],
              );
            }));
  }

  Widget _logout() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
        decoration: BoxDecoration(
            color: ThemseColors.secondColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          margin: EdgeInsets.only(bottom: 5, top: 5),
          child: Center(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Text('Đăng xuất',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    )),
              ),
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

                  // For Android
                  if (Platform.isAndroid) {
                    // Try call function from Kotlin with Json
                    await serviceBackgroudChannel.send(json.encode({
                      'command': 'stop_service',
                      'description': 'Stop Service'
                    }));
                  }

                  // For IOS
                  if (Platform.isIOS) {}

                  notify('Đã đăng xuất', Colors.green);
                } else {
                  setState(() {
                    this._onLogout = false;
                  });
                }
              },
            ),
          ),
        ));
  }

  Widget _device() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
      decoration: BoxDecoration(
          color: ThemseColors.secondColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        margin: EdgeInsets.only(bottom: 5, top: 5),
        child: Center(
            child: InkWell(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Text('Các thiết bị',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                )),
          ),
          onTap: () {
            if (this._accModel != null) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      DeviceScreen(this._accModel.place_name)));
            }
          },
        )),
      ),
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
                    _accountHeader(),
                    // info
                    _info(),
                    // Device
                    _device(),
                    SizedBox(
                      height: 15,
                    ),
                    // Logout
                    _logout()
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

import 'package:flutter/material.dart';
import 'package:o2_mobile/blocs/DeviceBloC.dart';
import 'package:o2_mobile/ui/ThemseColors.dart';
import 'package:o2_mobile/models/DeviceModel.dart' as DeviceModel;

class DeviceScreen extends StatefulWidget {
  String _place_name;
  DeviceScreen(this._place_name);
  @override
  State<StatefulWidget> createState() {
    return _DeviceState(this._place_name);
  }
}

class _DeviceState extends State<DeviceScreen> {
  String _place_name;
  // true: on, false: off
  List<Color> _colorList = List();
  List<String> _deviceList = List();
  List<Widget> _loadingList = List();
  Color _on = Colors.blue;
  Color _off = Colors.blue.withOpacity(0.4);
  _DeviceState(this._place_name);

  Widget _item(int index) {
    return Container(
        width: 70,
        height: 70,
        margin: EdgeInsets.only(right: 35, bottom: 15),
        decoration: BoxDecoration(
            color: this._colorList[index],
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: InkWell(
          onTap: () {
            setState(() {
              this._loadingList[index] = CircularProgressIndicator(
                backgroundColor: Colors.white,
              );
            });
            /*
            if (this._colorList[index] == this._on)
                this._colorList[index] = this._off;
              else
                this._colorList[index] = this._on;
            */
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
                child: Stack(
              children: <Widget>[
                Text(
                  this._deviceList[index],
                  style: TextStyle(color: Colors.white),
                ),
                this._loadingList[index]
              ],
            )),
          ),
        ));
  }

  Widget _place() {
    int index = -1;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 15, right: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: ThemseColors.secondColor,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 20,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: FractionalOffset.centerLeft,
              child: Text(
                this._place_name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          this._deviceList.length != 0
              ? Container(
                  padding: EdgeInsets.all(15),
                  child: Wrap(
                    // Do it for setState()
                    children: this._deviceList.map((item) {
                      index++;
                      return _item(index);
                    }).toList(),
                  ),
                )
              : CircularProgressIndicator()
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    deviceBloC.loadState();
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
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: devicePushlishSubject.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasError) {
                if (snapshot.hasData) {
                  DeviceModel.State state = snapshot.data;
                  if (state.code == 200) {
                    this._loadingList.add(Text(''));
                    this._loadingList.add(Text(''));
                    this._loadingList.add(Text(''));
                    this._loadingList.add(Text(''));

                    if (state.devices.lights.light_1 == '1')
                      this._colorList.add(this._on);
                    else
                      this._colorList.add(this._off);

                    if (state.devices.fans.fan_1 == '1')
                      this._colorList.add(this._on);
                    else
                      this._colorList.add(this._off);

                    if (state.devices.awnings.awning_1 == '1')
                      this._colorList.add(this._on);
                    else
                      this._colorList.add(this._off);

                    if (state.devices.pumps.pump_1 == '1')
                      this._colorList.add(this._on);
                    else
                      this._colorList.add(this._off);
                    // Clear and add again for function setState()
                    this._deviceList.clear();
                    this
                        ._deviceList
                        .add(state.devices.lights.runtimeType.toString());
                    this
                        ._deviceList
                        .add(state.devices.fans.runtimeType.toString());
                    this
                        ._deviceList
                        .add(state.devices.awnings.runtimeType.toString());
                    this
                        ._deviceList
                        .add(state.devices.pumps.runtimeType.toString());

                    return _place();
                  }
                } else
                  print(snapshot.error);
              }

              return _place();
            },
          )
        ],
      ),
    );
  }
}

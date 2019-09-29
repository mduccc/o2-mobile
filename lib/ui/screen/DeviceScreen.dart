import 'package:flutter/material.dart';
import 'package:o2_mobile/ui/ThemseColors.dart';

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
  Color _on = Colors.blue;
  Color _off = Colors.blue.withOpacity(0.4);
  _DeviceState(this._place_name);

  Widget _item(String name, int index) {
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
              if (this._colorList[index] == this._on)
                this._colorList[index] = this._off;
              else
                this._colorList[index] = this._on;
            });
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
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
          Container(
            padding: EdgeInsets.all(15),
            child: Wrap(
              children: this._deviceList.map((item) {
                index++;
                return _item(item, index);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    this._colorList.add(this._on);
    this._colorList.add(this._off);
    this._colorList.add(this._off);
    this._colorList.add(this._off);

    // Clear and add again for function setState()
    this._deviceList.clear();
    this._deviceList.add('Light');
    this._deviceList.add('Fan');
    this._deviceList.add('Pump');
    this._deviceList.add('Awning');
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
        children: <Widget>[_place()],
      ),
    );
  }
}

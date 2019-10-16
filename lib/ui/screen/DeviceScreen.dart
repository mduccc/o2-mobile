import 'package:flutter/material.dart';
import 'package:o2_mobile/blocs/DeviceBloC.dart';
import 'package:o2_mobile/business/DeviceControlProvider.dart';
import 'package:o2_mobile/ui/ThemseColors.dart';
import 'package:o2_mobile/models/DeviceModel.dart' as DeviceModel;

class DeviceGroup extends StatefulWidget {
  DeviceModel.Group groupData;
  DeviceGroup(this.groupData);

  @override
  State<StatefulWidget> createState() {
    return _DeviceGroupState(this.groupData);
  }
}

class _DeviceGroupState extends State<DeviceGroup> {
  DeviceModel.Group _groupData;
  _DeviceGroupState(this._groupData);
  Color _on = Colors.blue;
  Color _off = Colors.blue.withOpacity(0.1);
  List<Widget> _animate = List();

  Widget _item(Map<String, dynamic> device, index) {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.only(right: 15, bottom: 15, left: 15),
      decoration: BoxDecoration(
          color: device[device.keys.first] == '1' ? this._on : this._off,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: InkWell(
        onTap: () async {
          print('Switching ' + device.keys.first);
          setState(() {
            // Update UI
            this._animate[index] = CircularProgressIndicator(
              backgroundColor: Colors.white,
            );
          });

          DeviceModel.Switch _switch = await deviceControlProvider.switch_(
              device.keys.first,
              this._groupData.devices[device.keys.first] == '0' ? '1' : '0');

          if (_switch.code == 200) {
            setState(() {
              // Update UI
              this._groupData.devices[device.keys.first] =
                  this._groupData.devices[device.keys.first] == '0' ? '1' : '0';
            });
          }
          setState(() {
            // Update UI
            this._animate[index] = Text('');
          });
        },
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Stack(
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  child: Center(
                    child: Text(
                      (device.keys.first[0].toUpperCase() +
                          device.keys.first.substring(1).replaceAll('_', ' ')),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  child: this._animate[index],
                )
              ],
            )),
      ),
    );
  }

  Widget _group() {
    int index = -1;
    List<Map<String, dynamic>> devices = List();

    // Add data to map
    for (var key in this._groupData.devices.keys) {
      devices.add(Map.from({key: this._groupData.devices[key]}));
      this._animate.add(Text(''));
    }

    // Sort device by device id
    for (int i = 0; i < devices.length - 1; i++) {
      for (int j = i + 1; j < devices.length; j++) {
        if (int.parse(devices[i]
                .keys
                .first
                .substring(devices[i].keys.first.indexOf('_') + 1)) >
            int.parse(devices[j]
                .keys
                .first
                .substring(devices[j].keys.first.indexOf('_') + 1))) {
          var temp = devices[i];
          devices[i] = devices[j];
          devices[j] = temp;
        }
      }
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
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
                this._groupData.groupName[0].toUpperCase() +
                    this._groupData.groupName.substring(1),
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
                // Do it for setState()
                children: devices.map((value) {
                  index++;
                  return _item(value, index);
                }).toList(),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _group();
  }
}

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
  List<DeviceModel.Group> _groups = List();
  _DeviceState(this._place_name);

  Widget _deviceGroups() {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: this._groups.map((group) {
          return DeviceGroup(group);
        }).toList(),
      ),
    ));
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
        title: Text('Điều khiển các thiết bị'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: ThemseColors.primaryColor,
      body: StreamBuilder(
          stream: devicePushlishSubject.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasError) {
              if (snapshot.hasData) {
                DeviceModel.State state = snapshot.data;
                if (state.code == 200) {
                  this._groups.clear();
                  Map<String, dynamic> devices = state.devices;
                  List<String> devices_key_sorted = devices.keys.toList()
                    ..sort();
                  for (var device_group_key in devices_key_sorted) {
                    DeviceModel.Group group = DeviceModel.Group();
                    group.groupName = device_group_key;
                    group.devices = Map.from(devices[device_group_key]);
                    this._groups.add(group);
                  }
                  return _deviceGroups();
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            } else
              print(snapshot.error);

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

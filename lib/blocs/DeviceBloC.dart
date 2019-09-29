import 'package:o2_mobile/business/DeviceControlProvider.dart';
import 'package:o2_mobile/models/DeviceModel.dart';
import 'package:rxdart/rxdart.dart';

final devicePushlishSubject = PublishSubject<State>();

class DeviceBloC {
  Future loadState() async {
    print('hahaha');
    State state = await deviceControlProvider.state();
    devicePushlishSubject.add(state);
  }
}

final deviceBloC = DeviceBloC();

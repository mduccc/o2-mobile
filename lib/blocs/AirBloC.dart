import 'package:o2_mobile/blocs/AirStream.dart';
import 'package:o2_mobile/business/AirProvider.dart';
import 'package:o2_mobile/models/AirModel.dart';

class AirBloC {
  Future loadAirToday() async {
    AirModel airModel = await airProvider.loadAirToday();
    airTodayStream.add(airModel);
  }

  Future loadAirCurrent() async {
    AirModel airModel = await airProvider.loadAirCurrent();
    airCurrentStream.add(airModel);
  }
}

final airBloC = AirBloC();

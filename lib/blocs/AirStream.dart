import 'package:o2_mobile/models/AirModel.dart';
import 'package:rxdart/rxdart.dart';

final airTodayStream = PublishSubject<AirModel>();
final airCurrentStream = PublishSubject<AirModel>();

class Datas {
  String temp, uv, fire, gas, rain, dust, humidity, co, smoke, soil;

  Datas(
      {this.temp,
      this.uv,
      this.fire,
      this.gas,
      this.rain,
      this.dust,
      this.humidity,
      this.co,
      this.smoke,
      this.soil});
  factory Datas.fromJson(Map<String, dynamic> json) {
    return Datas(
        temp: json['temp'],
        uv: json['uv'],
        fire: json['fire'],
        gas: json['gas'],
        rain: json['rain'],
        dust: json['dust'],
        humidity: json['humidity'],
        co: json['co'],
        smoke: json['smoke'],
        soil: json['soil']);
  }
}

class Time {
  String time, time_id;
  Datas datas;

  Time({this.time, this.time_id, this.datas});
  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
        time: json['time'],
        time_id: json['time_id'],
        datas: Datas.fromJson(json['datas']));
  }
}

class Place {
  String place_id, place_name;
  List<Time> times;

  Place({this.place_id, this.place_name, this.times});
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        place_id: json['place_id'],
        place_name: json['place_name'],
        times: (json['times'] as List)
            .map((value) => Time.fromJson(value))
            .toList());
  }
}

class AirModel {
  int code;
  String message;
  List<Place> places;

  AirModel({this.code, this.message, this.places});
  factory AirModel.fromJson(Map<String, dynamic> json) {
    return AirModel(
        code: json['code'],
        message: json['message'],
        places: (json['places'] as List)
            .map((value) => Place.fromJson(value))
            .toList());
  }
}

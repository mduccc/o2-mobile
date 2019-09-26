class Sensors {
  String soil, uv, smoke, fire, co, gas, rain, dust, humidity;
  Sensors(
      {this.soil,
      this.uv,
      this.smoke,
      this.fire,
      this.co,
      this.gas,
      this.rain,
      this.dust,
      this.humidity});

  factory Sensors.fromJson(Map<String, dynamic> json) {
    return Sensors(
      soil: json['soil'],
      uv: json['uv'],
      smoke: json['smoke'],
      fire: json['fire'],
      co: json['co'],
      gas: json['gas'],
      rain: json['rain'],
      dust: json['dust'],
      humidity: json['humidity'],
    );
  }
}

class State {
  int code;
  String message;
  Sensors sensors;

  State({this.code, this.message, this.sensors});

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      code: json['code'],
      message: json['message'],
      sensors: json['sensors'],
    );
  }
}

class Switch {
  int code;
  String message;

  Switch({this.code, this.message});

  factory Switch.fromJson(Map<String, dynamic> json) {
    return Switch(
      code: json['code'],
      message: json['message'],
    );
  }
}

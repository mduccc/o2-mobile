class Pumps {
  String pump_1;

  Pumps({this.pump_1});
  factory Pumps.fromJson(Map<String, dynamic> json) {
    return Pumps(pump_1: json['pump_1']);
  }
}

class Awnings {
  String awning_1;

  Awnings({this.awning_1});
  factory Awnings.fromJson(Map<String, dynamic> json) {
    return Awnings(awning_1: json['awning_1']);
  }
}

class Fans {
  String fan_1;

  Fans({this.fan_1});
  factory Fans.fromJson(Map<String, dynamic> json) {
    return Fans(fan_1: json['fan_1']);
  }
}

class Lights {
  String light_1;

  Lights({this.light_1});
  factory Lights.fromJson(Map<String, dynamic> json) {
    return Lights(light_1: json['light_1']);
  }
}

class Devices {
  Pumps pumps;
  Awnings awnings;
  Fans fans;
  Lights lights;

  Devices({this.pumps, this.awnings, this.fans, this.lights});

  factory Devices.fromJson(Map<String, dynamic> json) {
    return Devices(
        pumps: Pumps.fromJson(json['pumps']),
        awnings: Awnings.fromJson(json['awnings']),
        fans: Fans.fromJson(json['fans']),
        lights: Lights.fromJson(json['lights']));
  }
}

class State {
  int code;
  String message;
  Devices devices;

  State({this.code, this.message, this.devices});

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      code: json['code'],
      message: json['message'],
      devices: Devices.fromJson(json['devices']),
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

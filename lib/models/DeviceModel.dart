class State {
  int code;
  String message;
  dynamic devices;

  State({this.code, this.message, this.devices});

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      code: json['code'],
      message: json['message'],
      devices: json['devices'],
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

class Group {
  String groupName;
  Map<String, dynamic> devices;
}

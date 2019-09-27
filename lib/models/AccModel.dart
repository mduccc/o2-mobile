class AccModel {
  int code;
  String token, accID, email, place_id, place_name;

  AccModel(
      {this.code,
      this.token,
      this.accID,
      this.email,
      this.place_id,
      this.place_name});
  factory AccModel.fromJson(Map<String, dynamic> json) {
    return AccModel(
        code: json['code'],
        token: json['token'],
        accID: json['accID'],
        email: json['email'],
        place_id: json['place_id'],
        place_name: json['place_name']);
  }
}

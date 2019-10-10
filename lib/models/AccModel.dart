class Coord {
  String lat, lon;

  Coord({this.lat, this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}

class AccModel {
  int code;
  String token, accID, email, place_id, place_name;
  Coord place_coord;

  AccModel(
      {this.code,
      this.token,
      this.accID,
      this.email,
      this.place_id,
      this.place_name,
      this.place_coord});
  factory AccModel.fromJson(Map<String, dynamic> json) {
    return AccModel(
        code: json['code'],
        token: json['token'],
        accID: json['accID'],
        email: json['email'],
        place_id: json['place_id'],
        place_name: json['place_name'],
        place_coord: json['place_coord']);
  }
}

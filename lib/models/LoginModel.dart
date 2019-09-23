class LoginModel {
  int code;
  String message, token;
  LoginModel({this.code, this.message, this.token});

  toMap() {
    return {'token': this.token};
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        code: json['code'], message: json['message'], token: json['token']);
  }
}

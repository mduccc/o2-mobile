import 'package:o2_mobile/business/LoginProvider.dart';
import 'package:o2_mobile/models/LoginModel.dart';
import 'package:rxdart/rxdart.dart';

// unnecessary to call this class
class LoginBloC {
  final publishSubject = PublishSubject<LoginModel>();
  final _login = LoginProvider();

  load(String username, String password) async {
    LoginModel loginData = await _login.valid(username, password);
    publishSubject.add(loginData);
  }
}

final loginBloC = LoginBloC();

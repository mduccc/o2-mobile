import 'package:o2_mobile/business/DatabaseProvider.dart';
import 'package:o2_mobile/business/LoginProvider.dart';
import 'package:o2_mobile/models/AccModel.dart';
import 'package:o2_mobile/models/LoginModel.dart';
import 'package:rxdart/rxdart.dart';

final loginPublishSubject = PublishSubject<LoginModel>();
final accInfoPublishSubject = PublishSubject<AccModel>();

class LoginBloC {
  final _login = LoginProvider();

  Future load(String username, String password) async {
    LoginModel loginData = await this._login.valid(username, password);
    loginPublishSubject.add(loginData);
  }

  Future info() async {
    await databaseProvider.openOrCreate();
    AccModel accModel = await this._login.info();
    accInfoPublishSubject.add(accModel);
  }
}

final loginBloC = LoginBloC();

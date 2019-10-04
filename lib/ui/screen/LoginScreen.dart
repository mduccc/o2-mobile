import 'package:flutter/material.dart';
import 'package:o2_mobile/business/DatabaseProvider.dart';
import 'package:o2_mobile/business/HTML.dart';
import 'package:o2_mobile/business/LoginProvider.dart';
import 'package:o2_mobile/models/LoginModel.dart';
import 'package:o2_mobile/ui/ThemseColors.dart';
import 'package:o2_mobile/ui/screen/HomeScreen.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameEdittingController = TextEditingController();
  TextEditingController _passwordEdittingController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  LoginProvider _loginProvider = LoginProvider();
  bool _onLogin = false;

  notify(String message, Color bgColor) {
    if (message != null && bgColor != null)
      Toast.show(message, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: bgColor);
  }

  goToHomeIfAvailable() async {
    // Go to HomeScreen if available
    if (await databaseProvider.tokenTableIsEmpty() == false) {
      print('Logged');
      /* 
        use pushReplacement() will replaced current path in router with HomeScreen.
        *
        Don't use pop(), cause pop() will replaced current path with last path in rourter, 
        but current is first path in router therefor can't find last path and will returned a black screen
      */
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            Container(
              color: ThemseColors.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: Container(
                          width: double.infinity,
                          color: ThemseColors.primaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'Air monitor',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.timeline,
                                color: Colors.white,
                                size: 35,
                              ),
                            ],
                          ))),
                  Expanded(
                      flex: 4,
                      child: Container(
                        color: ThemseColors.primaryColor,
                        padding: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Container(
                                  color: ThemseColors.primaryColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ThemseColors.secondColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                        margin: EdgeInsets.only(bottom: 10),
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 20,
                                            top: 3,
                                            bottom: 3),
                                        child: TextField(
                                          controller:
                                              this._usernameEdittingController,
                                          focusNode: this._usernameFocusNode,
                                          onSubmitted: (value) => {
                                            FocusScope.of(context).requestFocus(
                                                this._passwordFocusNode)
                                          },
                                          cursorColor: Colors.white,
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.9)),
                                          textInputAction: TextInputAction.next,
                                          cursorRadius: Radius.circular(16.0),
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Tên đăng nhập',
                                              icon: Icon(
                                                Icons.account_circle,
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          color: ThemseColors.secondColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 20,
                                            top: 3,
                                            bottom: 3),
                                        child: TextField(
                                          controller:
                                              this._passwordEdittingController,
                                          focusNode: this._passwordFocusNode,
                                          cursorColor: Colors.white,
                                          obscureText: true,
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.9)),
                                          textInputAction: TextInputAction.done,
                                          cursorRadius: Radius.circular(16.0),
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Mật khẩu',
                                              icon: Opacity(
                                                opacity: 0.9,
                                                child: Image.asset(
                                                  'assets/password.png',
                                                  scale: 4,
                                                ),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                    child: Align(
                                  alignment: FractionalOffset.topRight,
                                  child: Container(
                                    child: FlatButton(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 12,
                                            bottom: 12,
                                            left: 25,
                                            right: 25),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'Tiếp tục',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                      color: ThemseColors.secondColor,
                                      textColor: ThemseColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      onPressed: () async {
                                        if (this
                                                ._usernameEdittingController
                                                .text
                                                .isNotEmpty &&
                                            this
                                                ._passwordEdittingController
                                                .text
                                                .isNotEmpty) {
                                          setState(() {
                                            this._onLogin = true;
                                          });
                                          // Call login method
                                          LoginModel loginModel = await this
                                              ._loginProvider
                                              .valid(
                                                  this
                                                      ._usernameEdittingController
                                                      .text,
                                                  this
                                                      ._passwordEdittingController
                                                      .text);

                                          // Check login result
                                          if (loginModel != null) {
                                            if (loginModel.code == 200) {
                                              notify(
                                                  'Đã đăng nhập', Colors.green);

                                              // Open DB
                                              await databaseProvider
                                                  .openOrCreate();

                                              // Save DB
                                              await databaseProvider
                                                  .insertToken(loginModel);

                                              // Try get token from DB
                                              String tokenFromDB =
                                                  await databaseProvider
                                                      .getToken();
                                              print('Token from DB: ' +
                                                  tokenFromDB.toString());

                                              // Go to HomeScreen
                                              goToHomeIfAvailable();
                                            } else {
                                              if (loginModel.code == 401)
                                                notify(
                                                    'Sai thông tin đăng nhập',
                                                    Colors.orange);
                                              else
                                                notify(loginModel.message,
                                                    Colors.orange);
                                              setState(() {
                                                this._onLogin = false;
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              this._onLogin = false;
                                            });
                                            notify('Please check network',
                                                Colors.orange);
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                )))
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        width: double.infinity,
                        color: ThemseColors.primaryColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            // Container(
                            //   padding: EdgeInsets.only(bottom: 5),
                            //   child: Text(
                            //     'Chưa có tài khoản? Đăng ký ngay',
                            //     style: TextStyle(
                            //       fontSize: 13,
                            //       fontWeight: FontWeight.w300,
                            //       color: Colors.white.withOpacity(0.6),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              child: Text(
                                'Code with ' +
                                    HTML.decode('&#10084;') +
                                    ' in ICTU',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            this._onLogin
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: ThemseColors.primaryColor.withOpacity(0.6),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Center(),
          ],
        ),
      ),
    );
  }
}

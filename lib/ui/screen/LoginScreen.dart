import 'package:flutter/material.dart';
import 'package:o2_mobile/business/DatabaseProvider.dart';
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
        child: Container(
          color: ThemseColors.primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    width: double.infinity,
                    color: ThemseColors.primaryColor,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.9)),
                      ),
                    )),
              ),
              Expanded(
                  flex: 5,
                  child: Container(
                    color: ThemseColors.primaryColor,
                    padding: EdgeInsets.only(left: 25, right: 25),
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
                                    margin: EdgeInsets.only(bottom: 15),
                                    padding: EdgeInsets.only(
                                        left: 15, right: 20, top: 3, bottom: 3),
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
                                          color: Colors.white.withOpacity(0.9)),
                                      textInputAction: TextInputAction.next,
                                      cursorRadius: Radius.circular(16.0),
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Username',
                                          icon: Icon(
                                            Icons.account_circle,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          hintStyle: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.3))),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: ThemseColors.secondColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                    padding: EdgeInsets.only(
                                        left: 15, right: 20, top: 3, bottom: 3),
                                    child: TextField(
                                      controller:
                                          this._passwordEdittingController,
                                      focusNode: this._passwordFocusNode,
                                      cursorColor: Colors.white,
                                      obscureText: true,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9)),
                                      textInputAction: TextInputAction.done,
                                      cursorRadius: Radius.circular(16.0),
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Password',
                                          icon: Opacity(
                                            opacity: 0.5,
                                            child: Image.asset(
                                              'assets/password.png',
                                              scale: 4,
                                            ),
                                          ),
                                          hintStyle: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.3))),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                                width: double.infinity,
                                color: ThemseColors.primaryColor,
                                padding: EdgeInsets.only(top: 25),
                                child: Align(
                                  alignment: FractionalOffset.topCenter,
                                  child: Container(
                                    width: double.infinity,
                                    child: FlatButton(
                                      child: Container(
                                        margin: EdgeInsets.all(15),
                                        child: Text(
                                          'Go',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      color: Color(0xff9c4dcc),
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
                                              notify(loginModel.message,
                                                  Colors.green);

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
                                            } else
                                              notify(loginModel.message,
                                                  Colors.orange);
                                          } else
                                            notify('Please check network',
                                                Colors.orange);
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
                    width: double.infinity,
                    color: ThemseColors.primaryColor,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Text(
                          'No account? Register now',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

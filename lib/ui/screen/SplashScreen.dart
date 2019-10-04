import 'package:flutter/material.dart';
import 'package:o2_mobile/business/DatabaseProvider.dart';
import 'package:o2_mobile/ui/screen/LoginScreen.dart';

import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  DatabaseProvider _databaseProvider = DatabaseProvider();

  goToLoginOrHome() async {
    // Go to HomeScreen if available
    if (await this._databaseProvider.tokenTableIsEmpty() == false) {
      print('User logged');
      /* 
        use pushReplacement() will replaced current path in router with HomeScreen.
        *
        Don't use pop(), cause pop() will replaced current path with last path in rourter, 
        but current is first path in router therefor can't find last path and will returned a black screen
      */
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print('User has not logged yet');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // In first times user open app => create DB and go to HomeScreen if available
    _databaseProvider.openOrCreate().then((_) async {
      await goToLoginOrHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xff121212),
          child: Icon(
            Icons.timeline,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:o2_mobile/ui/screen/SplashScreen.dart';

void main() => runApp(App());

/* App is a widget, App contain many child widget 
(each screen is widget, content of screens are widgets too, all are widgets) */
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Monitor',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home:
          SplashScreen(), // router of MaterialApp will set home page is this Widget
    );
  }
}

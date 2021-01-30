import 'package:flutter/material.dart';
import 'package:operator_room/Homepage/HomePage.dart';
import 'package:operator_room/LoginPage/LoginPage.dart';
import 'package:operator_room/TeamDetails/src/TeamPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => Loginpage(),
        '/homepage': (context) => HomePage(),
        '/teampage': (context) => TeamPage(),
      },
    );
  }
}

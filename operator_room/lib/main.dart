import 'package:flutter/material.dart';
import 'package:operator_room/LoginPage/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LoginPage(),
      },
    );
  }
}

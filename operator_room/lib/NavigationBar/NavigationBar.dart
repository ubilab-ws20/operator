import 'package:flutter/material.dart';
import 'package:operator_room/NavigationBar/src/NavBar.dart';
import 'package:operator_room/NavigationBar/src/UniLab.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 100.0,
        color: Color(0xff333951),
        child: Stack(
          children: [
            UniLab(),
            Align(
              alignment: Alignment.center,
              child: NavBar(),
            ),
          ],
        ),
      ),
    );
  }
}

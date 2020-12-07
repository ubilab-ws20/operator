import 'package:flutter/material.dart';
import 'package:operator_room/NavigationBar/NavigationBar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:operator_room/TeamDetails/TeamDetails.dart';
import 'package:operator_room/TeamDetails/src/Teams.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    title: "Scavenger_Hunt",
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scavenger_Hunt"),
        backgroundColor: Color(0xff333951),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue[50],
        child: Stack(
          children: [
            //NavigationBar(),
            TeamDetails(),
          ],
        ),
      ),
    );
  }
}

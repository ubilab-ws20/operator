import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:operator_room/globals.dart';
import 'package:operator_room/TeamDetails/TeamDetails.dart';
import 'package:latlong/latlong.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map teamDetails = {};
  Timer _everySecond;
  int percentage;
  @override
  void initState() {
    super.initState();
    // sets first value
    teamDetails = {};
    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        print("Timer Called");
        if (mqttConnected == true) {
          //print("Updating...");
          teamDetails = manager.update();
          //print("HomePage $teamDetails");
          if (teamDetails != null && teamDetails.length > 0) {
            for (var v in teamDetails.keys) {
              print("Key: $v");
              List<String> team = teamDetails[v];
              if (team.length > 0) {
                print("TeamDetails is not Empty $team");
                if (globalTeamName.contains(team[0])) {
                  int index = globalTeamName.indexOf(team[0]);
                  globalTeamSize[index] = team[1];
                  globalHintsUsed[index] = team[2];
                  globalProgressPercentage[index] = team[3];
                } else {
                  globalTeamName.add(team[0]);
                  globalTeamSize.add(team[1]);
                  globalHintsUsed.add(team[2]);
                  globalProgressPercentage.add(team[3]);
                }
                team.clear();
              }
              //globalCurrentPuzzleInfo.add(team[4]);
            }
            print("TeamNames:$globalTeamName");
          }
        } else {
          manager.initialiseMQTTClient();
          manager.connect();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mqttConnected == false || isLoggedIn == false) {
      isLoggedIn = true;
      print("Connected");
      manager.initialiseMQTTClient();
      manager.connect();
    }
    //print(manager.client.connectionStatus);
    //jsonDecode(teamDetails);
    print(teamDetails);
    //sleep(Duration(seconds: 10));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scavenger_Hunt',
          style: TextStyle(fontSize: 40, fontFamily: 'Piazzolla'),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              manager.disconnect();
              isLoggedIn = false;
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false,
              );
            },
            child: Text("LOG OUT"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        backgroundColor: Color(0xff333951),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //color: Colors.blue[50],
            child: Stack(
              children: [
                TeamDetails(teamNames: teamDetails),
                AnimatedContainer(
                  margin: EdgeInsets.only(
                      top: 275, bottom: 20, left: 20, right: 20),
                  padding: EdgeInsets.all(5),
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  duration: Duration(milliseconds: 300),
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(48.012684, 7.835044),
                      zoom: 16.0,
                    ),
                    //mapController: mapController,
                    layers: [
                      MarkerLayerOptions(markers: [
                        Marker(
                          width: 80.0,
                          //height: 80.0,
                          point: LatLng(48.01264449144642, 7.835027628699855),
                          builder: (context) => Container(
                            child: IconButton(
                              icon: Icon(Icons.location_on_sharp),
                              color: Color(0xff914BA9),
                              iconSize: 25.0,
                              onPressed: () {
                                print("Location 1 Pressed");
                              },
                            ),
                          ),
                        ),
                        Marker(
                          width: 80.0,
                          //height: 80.0,
                          point: LatLng(48.01226852265323, 7.834826910032458),
                          builder: (context) => Container(
                            child: IconButton(
                              icon: Icon(Icons.location_on_sharp),
                              color: Color(0xffF1F354),
                              iconSize: 25.0,
                              onPressed: () {
                                print("Location 2 Pressed");
                              },
                            ),
                          ),
                        ),
                        Marker(
                          width: 80.0,
                          //height: 80.0,
                          point: LatLng(48.01257342478958, 7.835417156937603),
                          builder: (context) => Container(
                            child: IconButton(
                              icon: Icon(Icons.location_on_sharp),
                              color: Color(0xffDD3D1B),
                              iconSize: 25.0,
                              onPressed: () {
                                print("Location 3 Pressed");
                              },
                            ),
                          ),
                        ),
                        Marker(
                          width: 80.0,
                          //height: 80.0,
                          point: LatLng(48.012638019932446, 7.834515934710326),
                          builder: (context) => Container(
                            child: IconButton(
                              icon: Icon(Icons.location_on_sharp),
                              color: Colors.teal[900],
                              iconSize: 25.0,
                              onPressed: () {
                                print("Location 4 Pressed");
                              },
                            ),
                          ),
                        ),
                      ]),
                    ],
                    children: <Widget>[
                      TileLayerWidget(
                          options: TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _everySecond.cancel();
    super.dispose();
  }
}

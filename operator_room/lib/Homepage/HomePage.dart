import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:operator_room/TeamDetails/TeamDetails.dart';
import 'package:latlong/latlong.dart';
import 'package:operator_room/main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyApp(),
                ),
                (route) => false,
              );
            },
            child: Text("LOG OUT"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        backgroundColor: Color(0xff333951),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //color: Colors.blue[50],
            child: Stack(
              children: [
                TeamDetails(),
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
}

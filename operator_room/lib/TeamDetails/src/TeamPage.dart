import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:operator_room/globals.dart';

class TeamPage extends StatelessWidget {
  final String teamName = pageTeamName;
  final String hintsUsed = pageHintsUsed;
  final String currentPuzzle = pageCurrentPuzzle;
  final LatLng currentLocation = pageCurrentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teamName + " Details"),
        backgroundColor: Color(0xff333951),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.only(left: 300),
                  // ),

                  Container(
                    //padding: EdgeInsets.only(left: 300),
                    child: Column(
                      children: [
                        Text(
                          'Currently in:',
                          textAlign: TextAlign.left,
                          textScaleFactor: 1.5,
                          style: GoogleFonts.paprika(
                            fontSize: 10,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        Text(
                          pageCurrentPuzzle,
                          textAlign: TextAlign.left,
                          textScaleFactor: 1.5,
                          style: GoogleFonts.paprika(
                            fontSize: 10,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      teamName,
                      textAlign: TextAlign.left,
                      textScaleFactor: 1.5,
                      style: GoogleFonts.paprika(
                        fontSize: 30,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.only(left: 300),
                    child: Column(
                      children: [
                        Text(
                          'Number of hints used',
                          textAlign: TextAlign.left,
                          textScaleFactor: 1.5,
                          style: GoogleFonts.paprika(
                            fontSize: 10,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        Text(
                          hintsUsed,
                          textAlign: TextAlign.left,
                          textScaleFactor: 1.5,
                          style: GoogleFonts.paprika(
                            fontSize: 10,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              duration: Duration(milliseconds: 300),
              child: FlutterMap(
                options: MapOptions(
                  center: currentLocation,
                  zoom: 16.0,
                ),
                //mapController: mapController,
                layers: [
                  MarkerLayerOptions(markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: currentLocation,
                      builder: (context) => Container(
                        child: IconButton(
                          icon: Icon(Icons.location_on),
                          iconSize: 45.0,
                          onPressed: () {
                            print(teamName);
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
    );
  }
}

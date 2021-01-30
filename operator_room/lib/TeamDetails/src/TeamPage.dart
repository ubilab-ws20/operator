import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:google_fonts/google_fonts.dart';

class Arguments {
  final String teamname;
  final Color markerColor;

  Arguments(this.teamname, this.markerColor);
}

class TeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Arguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.teamname + " Details"),
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
                          'Puzzle 2',
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
                      args.teamname,
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
                          '2',
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
                  center: LatLng(48.012684, 7.835044),
                  zoom: 16.0,
                ),
                //mapController: mapController,
                layers: [
                  MarkerLayerOptions(markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(48.012677494702146, 7.834448879485198),
                      builder: (context) => Container(
                        child: IconButton(
                          icon: Icon(Icons.location_on),
                          color: args.markerColor,
                          iconSize: 45.0,
                          onPressed: () {
                            print(args.teamname);
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

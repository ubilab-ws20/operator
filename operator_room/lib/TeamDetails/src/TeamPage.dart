import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:operator_room/globals.dart';

class TeamPage extends StatelessWidget {
  final String _teamName = pageTeamName;
  final String _hintsUsed = pageHintsUsed;
  final String _currentPuzzle = pageCurrentPuzzle;
  double _currentZoom = 18.0;
  MapController _mapController = MapController();
  final LatLng _currentLocation = pageCurrentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_teamName + " Details"),
        backgroundColor: Color(0xff333951),
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Currently in:',
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.5,
                              style: GoogleFonts.paprika(
                                fontSize: 15,
                                color: Colors.blueGrey[700],
                              ),
                            ),
                            Text(
                              "Puzzle " + _currentPuzzle,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.5,
                              style: GoogleFonts.paprika(
                                fontSize: 20,
                                color: Colors.blueGrey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Text(
                          _teamName,
                          textAlign: TextAlign.left,
                          textScaleFactor: 1.5,
                          style: GoogleFonts.paprika(
                            fontSize: 30,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Number of hints used',
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.5,
                              style: GoogleFonts.paprika(
                                fontSize: 15,
                                color: Colors.blueGrey[700],
                              ),
                            ),
                            Text(
                              _hintsUsed,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.5,
                              style: GoogleFonts.paprika(
                                fontSize: 20,
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
                  margin:
                      EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 2),
                  padding: EdgeInsets.all(5),
                  height: 420,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  duration: Duration(milliseconds: 300),
                  child: FlutterMap(
                    options: MapOptions(
                      center: _currentLocation,
                      zoom: 16.0,
                    ),
                    mapController: _mapController,
                    layers: [
                      MarkerLayerOptions(markers: [
                        Marker(
                          width: 50.0,
                          height: 50.0,
                          point: _currentLocation,
                          builder: (context) => Container(
                            child: IconButton(
                              icon: Icon(Icons.location_on),
                              iconSize: 45.0,
                              onPressed: () {
                                print(_teamName);
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
                        ),
                      ),
                      FloatingActionButton.extended(
                        heroTag: "ZoomOutbtn",
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.grey[850],
                        onPressed: _zoomOut,
                        tooltip: 'ZoomOut',
                        label: Icon(Icons.zoom_out_sharp),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: FloatingActionButton.extended(
                          heroTag: "ZoomInbtn",
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.grey[850],
                          onPressed: _zoomIn,
                          tooltip: 'ZoomIn',
                          label: Icon(Icons.zoom_in_sharp),
                        ),
                      ),
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

  void _zoomOut() {
    if (_currentZoom > 0) {
      _currentZoom = _currentZoom - 0.15;
    } else {
      _currentZoom = 0;
    }
    _mapController.move(_currentLocation, _currentZoom);
  }

  void _zoomIn() {
    if (_currentZoom < 18.4) {
      _currentZoom = _currentZoom + 0.15;
    } else {
      _currentZoom = 18.4;
    }
    _mapController.move(_currentLocation, _currentZoom);
  }
}

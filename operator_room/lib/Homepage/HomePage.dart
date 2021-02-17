import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:operator_room/LoginPage/LoginPage.dart';
import 'package:operator_room/globals.dart';
import 'package:operator_room/TeamDetails/TeamDetails.dart';
import 'package:latlong/latlong.dart';

final String appNameString = "Scavenger Hunt";
final String logOutString = "Log Out";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map _teamDetails = {};
  Timer _homePageTimer;
  double _currentZoom = 18.0;
  MapController _mapController = MapController();
  LatLng _defaultLocation = LatLng(48.013217, 7.833264);

  /// Initialises the HomePage class
  @override
  void initState() {
    super.initState();
    // sets first value
    _teamDetails = {};
    if (globalIsTesting) {
      print("HomePage:: init()");
    }
    // defines a timer
    _homePageTimer = Timer.periodic(Duration(seconds: 4), (Timer t) {
      setState(() {
        if (mqttConnected == true) {
          callMqttUpdate();
        }
      });
    });
  }

  /// Navigate to LoginPage
  Future navigateToSubPage(context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appNameString,
          style: TextStyle(fontSize: 40, fontFamily: 'Piazzolla'),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              onLogoutPressed();
            },
            child: Text(
              logOutString,
              style: TextStyle(fontSize: 17, fontFamily: 'Piazzolla'),
            ),
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
                TeamDetails(teamNames: _teamDetails),
                AnimatedContainer(
                  margin:
                      EdgeInsets.only(top: 275, bottom: 2, left: 20, right: 20),
                  padding: EdgeInsets.all(5),
                  height: 500,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  duration: Duration(milliseconds: 300),
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(48.012684, 7.835044),
                      zoom: 16.0,
                    ),
                    mapController: _mapController,
                    layers: [
                      MarkerLayerOptions(markers: getMarkers()),
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

  /// Updates the team details received by the MQTT client
  void callMqttUpdate() {
    _teamDetails = manager.update();
    if (_teamDetails != null && _teamDetails.isNotEmpty) {
      for (var v in _teamDetails.keys) {
        var team = _teamDetails[v];
        if (globalTeamID.contains(team["teamID"])) {
          int index = globalTeamID.indexOf(team["teamID"]);
          globalHintsUsed[index] = team["hintsUsed"];
          globalProgressPercentage[index] = team["gameProgress"];
          globalCurrentPuzzleInfo[index] = team["currentPuzzle"];
          globalCurrentLocation[index] =
              LatLng(team['latitude'], team['longitude']);
        } else {
          globalTeamID.add(team["teamID"]);
          globalTeamName.add(team['teamName']);
          globalTeamSize.add(team["teamSize"]);
          globalHintsUsed.add(team["hintsUsed"]);
          globalProgressPercentage.add(team["gameProgress"]);
          globalCurrentPuzzleInfo.add(team["currentPuzzle"]);
          globalCurrentLocation
              .add(LatLng(team['latitude'], team['longitude']));
        }
      }
    }
  }

  /// Function executed when logout pressed
  void onLogoutPressed() {
    manager.disconnect();
    clearDetails();
    isLoggedIn = false;
    _homePageTimer.cancel();
    navigateToSubPage(context);
  }

  /// Get individual team Marker on Map
  List<Marker> getMarkers() {
    List<Marker> _markerList = [];
    if (_teamDetails.isNotEmpty) {
      for (var _users in globalCurrentLocation) {
        _markerList.add(
          Marker(
            width: 40.0,
            point: LatLng(_users.latitude, _users.longitude),
            builder: (context) => Container(
              child: IconButton(
                icon: Icon(Icons.location_on_sharp),
                color: Colors.teal[900],
                iconSize: 25.0,
                onPressed: () {},
              ),
            ),
          ),
        );
      }
      return _markerList;
    }
    return [];
  }

  /// Zoom Out from current location on Map
  void _zoomOut() {
    if (_currentZoom > 0) {
      _currentZoom = _currentZoom - 0.15;
    } else {
      _currentZoom = 0;
    }
    _mapController.move(_defaultLocation, _currentZoom);
  }

  /// Zoom In from current location on Map
  void _zoomIn() {
    if (_currentZoom < 18.4) {
      _currentZoom = _currentZoom + 0.15;
    } else {
      _currentZoom = 18.4;
    }
    _mapController.move(_defaultLocation, _currentZoom);
  }

  /// Cancel the timer
  @override
  void dispose() {
    _homePageTimer.cancel();
    super.dispose();
  }

  /// Clears the global variables
  void clearDetails() {
    _teamDetails.clear();
    globalCurrentPuzzleInfo.clear();
    globalHintsUsed.clear();
    globalProgressPercentage.clear();
    globalTeamName.clear();
    globalTeamSize.clear();
    globalCurrentLocation.clear();
  }
}

import 'package:latlong/latlong.dart';
import 'package:operator_room/MQTT/MqttManager.dart';

const String stringHostName =
    "wss://earth.informatik.uni-freiburg.de/ubilab/ws/";
const String globalLoginPassword = "abc123";

MQTTManager manager = MQTTManager(host: stringHostName);
bool isLoggedIn = false;
bool mqttConnected = true;

double globalMaxTime = 2;

String pageTeamName = "";
String pageCurrentPuzzle = "";
String pageHintsUsed = "";
LatLng pageCurrentLocation;

List<String> globalTeamName = [];
List<String> globalTeamID = [];
List<String> globalHintsUsed = [];
List<String> globalTeamSize = [];
List<String> globalProgressPercentage = [];
List<String> globalCurrentPuzzleInfo = [];
List<LatLng> globalCurrentLocation = [];

/// Debugging & Testing
final bool globalIsTesting = true;

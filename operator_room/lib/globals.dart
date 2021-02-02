import 'package:operator_room/MQTT/MqttManager.dart';

const String stringHostName =
    "wss://earth.informatik.uni-freiburg.de/ubilab/ws/";
const String globalLoginPassword = "abc123";

MQTTManager manager = MQTTManager(host: stringHostName);
bool isLoggedIn = false;
bool mqttConnected = true;

import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class MQTTManager {
  MqttBrowserClient client;
  final String _host;

  MQTTManager({@required String host}) : _host = host;

  void initialiseMQTTClient() {
    client = MqttBrowserClient.withPort(
        'ws://earth.informatik.uni-freiburg.de/ubilab/ws/',
        'flutter_client',
        443,
        maxConnectionAttempts: 1);

    //client.websocketProtocols = "https";

    //client.websocketProtocolString = "https";

    //client.port = 2121;
    client.keepAlivePeriod = 5;
    client.onConnected = onConnected;

    final connMessage = MqttConnectMessage().authenticateAs('ubilab', 'ubilab');

    client.connectionMessage = connMessage;
  }

  void connect() async {
    assert(client != null);
    try {
      print('EXAMPLE::start client connecting....');
      //_currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await client.connect('ubilab', 'ubilab');
      print("connected");
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    client.disconnect();
  }

  void onConnected() {
    print('EXAMPLE::Mosquitto client connected....');
  }
}

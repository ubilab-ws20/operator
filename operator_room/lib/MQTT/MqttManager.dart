import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class MQTTManager {
  MqttBrowserClient client;
  final String _host;
  final String topicName = "testID/testtopic";

  MQTTManager({@required String host}) : _host = host;

  void initialiseMQTTClient() {
    client = MqttBrowserClient(
        'wss://earth.informatik.uni-freiburg.de/ubilab/ws/', "TestID",
        maxConnectionAttempts: 1);

    //client.clientIdentifier = 'TestID';

    client.port = 443;
    client.keepAlivePeriod = 5;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    //final connMessage = MqttConnectMessage().authenticateAs('ubilab', 'ubilab');

    //client.connectionMessage = connMessage;
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
    _subscribeToTopic(topicName);
  }

  void _subscribeToTopic(String topicName) {
    print('MQTTClientWrapper::Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atMostOnce);
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }
}

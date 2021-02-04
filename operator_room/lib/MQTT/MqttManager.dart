import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:operator_room/globals.dart';

class MQTTManager {
  MqttBrowserClient client;
  final String _host;
  final String topicName = "testID/testtopic";
  //String payload;
  Map teamDetails = new Map();

  MQTTManager({@required String host}) : _host = host;

  void initialiseMQTTClient() {
    client = MqttBrowserClient(_host, "TestID", maxConnectionAttempts: 1);

    //client.clientIdentifier = 'TestID';

    client.port = 443;
    client.keepAlivePeriod = 5;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.autoReconnect = true;
    client.resubscribeOnAutoReconnect = true;
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

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      print("listen message:${c[0].payload}");
      final MqttPublishMessage message = c[0].payload;
      String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      if (!payload.contains("Disconnecting")) {
        print(payload);
        List<String> team = payload.split(",").toSet().toList();
        print(team);
        teamDetails[team[0]] = team;
        //team.clear();
      } else {
        List<String> team = payload.split(" ");
        teamDetails.remove(team[0]);
        team.clear();
      }
      print("MQTT TeamDetails:$teamDetails");
      message.setRetain(state: false);
      //message.payload.message.clear();
      print('Received message in operator:$payload from topic: ${c[0].topic}>');
    });
  }

  void disconnect() {
    _unsubscribeToTopic(topicName);
    teamDetails.clear();
    print('Disconnected');
    client.disconnect();
  }

  void onConnected() {
    print('EXAMPLE::Mosquitto client connected....');
    mqttConnected = true;
    _subscribeToTopic(topicName);
  }

  void _subscribeToTopic(String topicName) {
    print('MQTTClientWrapper::Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.exactlyOnce);
    //  publish(topicName);
  }

  void _unsubscribeToTopic(String topicName) {
    print('MQTTClientWrapper::Unsubscribing to the $topicName topic');
    client.unsubscribe(topicName);
    //  publish(topicName);
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

  void publish(String topic) {
    final builder = MqttClientPayloadBuilder();
    //builder.addString('Hello there MQTT: ');
    int val = 5;
    builder.addInt(val);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }

  Map update() {
    //teamDetails.add(payload);
    print("In Update");

    if (teamDetails == null) {
      return {};
    }
    print("Unique Team:$teamDetails");
    return teamDetails;
  }

  void onDisconnected() {
    mqttConnected = false;
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:operator_room/globals.dart';

class MQTTManager {
  MqttBrowserClient client;
  final String _host;
  final String topicName = "testID/scavenger_hunt";
  Map teamDetails = new Map();
  bool _subscribed = false;

  MQTTManager({@required String host}) : _host = host;

  void initialiseMQTTClient() {
    client = MqttBrowserClient(_host, "TestID", maxConnectionAttempts: 1);

    //client.clientIdentifier = 'TestID';

    client.port = 443;
    client.keepAlivePeriod = 15;
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
      //print('EXAMPLE::start client connecting....');
      await client.connect('ubilab', 'ubilab');
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      //print("listen message:${c[0].payload}");
      final MqttPublishMessage message = c[0].payload;
      String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      if (!payload.contains("disconnecting")) {
        var jsonObj = jsonDecode(payload);
        print("Jason: $jsonObj");
        teamDetails[jsonObj["teamName"]] = jsonObj;
      } else {
        print(payload);
        List<String> team = payload.split(" ");
        teamDetails.remove(team[0]);
        if (globalTeamName.contains(team[0])) {
          int index = globalTeamName.indexOf(team[0]);
          globalTeamName.remove(team[0]);
          globalTeamSize.remove(globalTeamSize[index]);
          globalHintsUsed.remove(globalHintsUsed[index]);
          globalProgressPercentage.remove(globalProgressPercentage[index]);
        }
        team.clear();
      }
      print("MQTT TeamDetails:$teamDetails");
      message.setRetain(state: false);
      //message.payload.message.clear();
      //print('Received message in operator:$payload from topic: ${c[0].topic}>');
    });
  }

  void disconnect() {
    if (isSubscribed()) {
      _unsubscribeToTopic(topicName);
    }
    if (mqttConnected) {
      client.disconnect();
    }
    return;
  }

  void onConnected() {
    print('EXAMPLE::Mosquitto client connected....');
    mqttConnected = true;
    _subscribeToTopic(topicName);
  }

  void _subscribeToTopic(String topicName) {
    print('MQTTClientWrapper::Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.exactlyOnce);
  }

  void _unsubscribeToTopic(String topicName) {
    print('MQTTClientWrapper::Unsubscribing to the $topicName topic');
    client.unsubscribe(topicName);
    _subscribed = false;
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
    _subscribed = true;
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
    _subscribed = false;
  }

  bool isSubscribed() {
    return _subscribed;
  }

  Map update() {
    print("In Update");
    if (teamDetails == null) {
      return {};
    }
    return teamDetails;
  }

  void onDisconnected() {
    mqttConnected = false;
    teamDetails.clear();
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:operator_room/globals.dart';

class MQTTManager {
  MqttBrowserClient _client;
  Timer _resetTimer;
  final String _host;
  bool _subscribed = false;
  Map _teamDetails = new Map();
  final String _topicName = "testID/scavenger_hunt";

  MQTTManager({@required String host}) : _host = host;

  void initialiseMQTTClient() {
    _client =
        MqttBrowserClient(_host, "${DateTime.now()}", maxConnectionAttempts: 1);

    _client.port = 443;
    _client.autoReconnect = true;
    _client.keepAlivePeriod = 15;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.onDisconnected = onDisconnected;
    _client.resubscribeOnAutoReconnect = true;
  }

  void connect() async {
    assert(_client != null);
    try {
      print('MQTTManager::connect()');
      await _client.connect('ubilab', 'ubilab');
    } on Exception catch (e) {
      print('MQTTManager::client exception - $e');
      disconnect();
    }

    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload;
      String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      if (!payload.contains("disconnecting")) {
        var jsonObj = jsonDecode(payload);
        print("Json: $jsonObj");
        _teamDetails[jsonObj["teamName"]] = jsonObj;
      } else {
        print(payload);
        List<String> team = payload.split(":");
        _teamDetails.remove(team[0]);
        if (globalTeamName.contains(team[0])) {
          int index = globalTeamName.indexOf(team[0]);
          globalTeamName.remove(team[0]);
          globalTeamSize.remove(globalTeamSize[index]);
          globalHintsUsed.remove(globalHintsUsed[index]);
          globalProgressPercentage.remove(globalProgressPercentage[index]);
        }
        team.clear();
      }
      print("MQTTManager::TeamDetails:$_teamDetails");
      message.setRetain(state: false);
    });
  }

  void disconnect() {
    print("MQTTManager::disconnect()");
    if (isSubscribed()) {
      _unsubscribeToTopic(_topicName);
    }
    if (mqttConnected) {
      _client.disconnect();
    }
    return;
  }

  void onConnected() {
    print("MQTTManager::onConnected()");
    mqttConnected = true;
    _subscribeToTopic(_topicName);
    _resetTimer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      print("MQTTManager::Clearing details");
      clearDetails();
    });
  }

  void _subscribeToTopic(String topicName) {
    print('MQTTManager::Subscribing to the $topicName topic');
    _client.subscribe(topicName, MqttQos.exactlyOnce);
  }

  void _unsubscribeToTopic(String topicName) {
    print('MQTTManager::Unsubscribing to the $topicName topic');
    _client.unsubscribe(topicName);
    _subscribed = false;
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('MQTTManager::Subscribed topic: $topic');
    _subscribed = true;
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('MQTTManager::onSubscribeFail() Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String topic) {
    print('MQTTManager::onUnsubscribed() Unsubscribed topic: $topic');
    _subscribed = false;
  }

  bool isSubscribed() {
    print('MQTTManager::isSubscribed()');
    return _subscribed;
  }

  Map update() {
    print('MQTTManager::Mapupdate()');
    if (_teamDetails == null) {
      return {};
    }
    return _teamDetails;
  }

  void onDisconnected() {
    print('MQTTManager::onDisconnected()');
    mqttConnected = false;
    if (_resetTimer.isActive) {
      _resetTimer.cancel();
    }

    clearDetails();
  }

  void clearDetails() {
    print('MQTTManager::clearDetails()');
    _teamDetails.clear();
    globalCurrentPuzzleInfo.clear();
    globalHintsUsed.clear();
    globalProgressPercentage.clear();
    globalTeamName.clear();
    globalTeamSize.clear();
    globalCurrentLocation.clear();
  }
}

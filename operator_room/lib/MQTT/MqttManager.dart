import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:operator_room/globals.dart';
import 'package:random_color/random_color.dart';

class MQTTManager {
  MqttBrowserClient _client;
  final String _host;
  bool _subscribed = false;
  Map _teamDetails = new Map();
  Map _prevTime = new Map();
  Map _countFlag = new Map();
  final String _topicName = "testID/scavenger_hunt";
  RandomColor _randomColor = RandomColor();

  MQTTManager({@required String host}) : _host = host;

  /// Initialise the MQTT client
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

  /// Connects to MQTT Browser client
  void connect() async {
    assert(_client != null);
    try {
      if (globalIsTesting) {
        print('MQTTManager::connect()');
      }
      await _client.connect('ubilab', 'ubilab');
    } on Exception catch (e) {
      if (globalIsTesting) {
        print('MQTTManager::client exception - $e');
      }
      disconnect();
    }

    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload;
      String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      var jsonObj = jsonDecode(payload);
      String teamID = jsonObj["teamID"];
      if (jsonObj["connected"]) {
        if (_teamDetails.containsKey(teamID)) {
          if (globalIsTesting) {
            print(
                "MQTTManager::TimeStamp:TeamDetails: ${_teamDetails[teamID]}");
          }
          _prevTime[teamID] = _teamDetails[teamID]["timeStamp"];
          var _color = _teamDetails[teamID]["teamColor"];
          _teamDetails[teamID] = jsonObj;
          _teamDetails[teamID]["teamColor"] = _color;
        } else {
          _teamDetails[teamID] = jsonObj;
          Color _color = _randomColor.randomColor(
              colorSaturation: ColorSaturation.highSaturation);
          _teamDetails[teamID]["teamColor"] = _color;
        }
        if (globalIsTesting) {
          print("MQTTManager::TimeStamp: $_prevTime");
        }
      } else {
        clearTeamDetails(teamID);
      }
    });
  }

  /// Disconnects from MQTT Browser client
  void disconnect() {
    if (globalIsTesting) {
      print("MQTTManager::disconnect()");
    }
    if (isSubscribed()) {
      _unsubscribeToTopic(_topicName);
    }
    if (mqttConnected) {
      _client.disconnect();
    }
    return;
  }

  /// Function called when connected to MQTT Browser Client succeeded
  void onConnected() {
    if (globalIsTesting) {
      print("MQTTManager::onConnected()");
    }
    mqttConnected = true;
    _subscribeToTopic(_topicName);
  }

  /// Function Subscribes to TopicName
  void _subscribeToTopic(String topicName) {
    if (globalIsTesting) {
      print('MQTTManager::Subscribing to the $topicName topic');
    }
    _client.subscribe(topicName, MqttQos.exactlyOnce);
  }

  /// Unsubscribes from the TopicName
  void _unsubscribeToTopic(String topicName) {
    if (globalIsTesting) {
      print('MQTTManager::Unsubscribing to the $topicName topic');
    }
    _client.unsubscribe(topicName);
    _subscribed = false;
  }

// Function called when Subscribe to topic succeeded
  void onSubscribed(String topic) {
    if (globalIsTesting) {
      print('MQTTManager::Subscribed topic: $topic');
    }
    _subscribed = true;
  }

// Subscribe to topic failed
  void onSubscribeFail(String topic) {
    if (globalIsTesting) {
      print('MQTTManager::onSubscribeFail() Failed to subscribe $topic');
    }
  }

// Function called when Unsubscribe succeeded
  void onUnsubscribed(String topic) {
    if (globalIsTesting) {
      print('MQTTManager::onUnsubscribed() Unsubscribed topic: $topic');
    }
    _subscribed = false;
  }

  /// Check if the client is still subscribed to the TopicName
  bool isSubscribed() {
    if (globalIsTesting) {
      print('MQTTManager::isSubscribed()');
    }
    return _subscribed;
  }

  /// Returns the updated Team details
  Map update() {
    List removeKeys = [];
    if (_teamDetails.isEmpty) {
      return {};
    } else if (_prevTime.isNotEmpty) {
      for (var key in _prevTime.keys) {
        var hours = double.parse(_prevTime[key].split(":")[0]);
        double progress = double.parse(_teamDetails[key]["gameProgress"]);
        if (_prevTime[key] == _teamDetails[key]["timeStamp"] ||
            hours >= globalMaxTime) {
          if (globalIsTesting) {
            print(
                "Mqtt Update function ${_prevTime[key]} and ${_teamDetails[key]["timeStamp"]} \n $progress");
          }
          if (_countFlag[key] == null) {
            _countFlag[key] = 1;
          } else if ((_countFlag[key] >= 5 && progress < 1) ||
              (_countFlag[key] >= 25 && progress == 1)) {
            removeKeys.add(key);
          } else {
            _countFlag[key]++;
          }
        } else {
          _prevTime[key] = _teamDetails[key]["timeStamp"];
          _countFlag[key] = 0;
        }
      }
    }
    for (var teamKey in removeKeys) {
      clearTeamDetails(teamKey);
    }
    removeKeys.clear();
    return _teamDetails;
  }

  /// Function called when disconnect is succeeded
  void onDisconnected() {
    if (globalIsTesting) {
      print('MQTTManager::onDisconnected()');
    }
    mqttConnected = false;
    clearAllDetails();
  }

  /// Clears the individual team details
  void clearTeamDetails(String teamID) {
    _teamDetails.remove(teamID);
    _prevTime.remove(teamID);
    _countFlag.remove(teamID);
    if (globalTeamID.contains(teamID)) {
      int index = globalTeamID.indexOf(teamID);
      globalTeamName.remove(globalTeamName[index]);
      globalTeamSize.remove(globalTeamSize[index]);
      globalHintsUsed.remove(globalHintsUsed[index]);
      globalProgressPercentage.remove(globalProgressPercentage[index]);
      globalCurrentLocation.remove(globalCurrentLocation[index]);
      globalTeamColor.remove(globalTeamColor[index]);
    }
    globalTeamID.remove(teamID);
  }

  /// Clears all global variables
  void clearAllDetails() {
    if (globalIsTesting) {
      print('MQTTManager::clearDetails()');
    }
    _teamDetails.clear();
    _prevTime.clear();
    _countFlag.clear();
    globalTeamID.clear();
    globalCurrentPuzzleInfo.clear();
    globalHintsUsed.clear();
    globalProgressPercentage.clear();
    globalTeamName.clear();
    globalTeamSize.clear();
    globalCurrentLocation.clear();
    globalTeamColor.clear();
  }
}

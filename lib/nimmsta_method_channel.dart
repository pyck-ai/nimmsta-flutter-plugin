import 'package:flutter/services.dart';

import 'nimmsta_event.dart';
import 'nimmsta_platform_interface.dart';

class MethodChannelNimmsta extends NimmstaPlatform {
  static const MethodChannel _methodChannel = MethodChannel('nimmsta/methods');

  static const EventChannel _eventChannel = EventChannel('nimmsta/events');

  static Stream<NimmstaEvent>? _callbackStream;

  @override
  Future<bool?> isConnected() async {
    return await _methodChannel.invokeMethod<bool>('isConnected');
  }

  @override
  Future<void> connect() async {
    return await _methodChannel.invokeMethod('connect');
  }

  @override
  Future<void> reconnect(String address) async {
    return await _methodChannel.invokeMethod("reconnect", {"address": address});
  }

  @override
  Future<void> disconnect() async {
    return await _methodChannel.invokeMethod('disconnect');
  }

  @override
  Future<void> setLayout(String layout,
      Map<String, String> data) async {
    return await _methodChannel.invokeMethod(
        "setLayout", {"layout": layout, "data": data});
  }

  @override
  Future<void> setScreenInfoAsync(Map<String, String> data) async {
    return await _methodChannel
        .invokeMethod("setScreenInfoAsync", {"data": data});
  }

  @override
  Future<void> setLEDColor(Color color) async {
    return await _methodChannel.invokeMethod(
        "setLEDColor",
        {
          "r": (color.r * 255).floor(),
          "g": (color.g * 255).floor(),
          "b": (color.b * 255).floor()
        });
  }

  @override
  Future<void> triggerLEDBurst(int repeat, int duration, int pulseDuration,
      Color color) async {
    return await _methodChannel.invokeMethod("triggerLEDBurst", {
      "repeat": repeat,
      "duration": duration,
      "pulseDuration": pulseDuration,
      "r": (color.r * 255).floor(),
      "g": (color.g * 255).floor(),
      "b": (color.b * 255).floor()
    });
  }

  @override
  Future<void> triggerVibrationBurst(int repeat, int duration,
      int pulseDuration, int intensity) async {
    return await _methodChannel.invokeMethod("triggerVibrationBurst", {
      "repeat": repeat,
      "duration": duration,
      "pulseDuration": pulseDuration,
      "intensity": intensity
    });
  }

  @override
  Future<void> triggerBeeperBurst(int repeat, int duration, int pulseDuration,
      int intensity) async {
    return await _methodChannel.invokeMethod("triggerBeeperBurst", {
      "repeat": repeat,
      "duration": duration,
      "pulseDuration": pulseDuration,
      "intensity": intensity
    });
  }

  @override
  Stream<NimmstaEvent> getCallbackStream() {
    _callbackStream ??=
        _eventChannel.receiveBroadcastStream().map<NimmstaEvent>(_mapToEvent);
    return _callbackStream!;
  }

  NimmstaEvent _mapToEvent(dynamic rawEvent) {
    final Map<String, dynamic> event = Map<String, dynamic>.from(rawEvent);
    final typeString = event['type'] as String;
    final data = Map<String, dynamic>.from(event['data']);

    final eventType = NimmstaEventType.values.byName(typeString);

    return NimmstaEvent(eventType, data);
  }
}

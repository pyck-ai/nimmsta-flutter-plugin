import 'dart:ui';

import 'nimmsta_platform_interface.dart';

class Nimmsta {
  final nimmstaPlugin = NimmstaPlatform.instance;

  Future<bool?> isConnected() {
    return nimmstaPlugin.isConnected();
  }

  Future<void> connect() {
    return nimmstaPlugin.connect();
  }

  Future<void> reconnect(String address) {
    return nimmstaPlugin.reconnect(address);
  }

  Future<void> disconnect() {
    return nimmstaPlugin.disconnect();
  }

  Future<void> setLayout(String layoutResource,
      Map<String, String> data) {
    return nimmstaPlugin.setLayout(layoutResource, data);
  }

  Future<void> setScreenInfoAsync(Map<String, String> data) {
    return nimmstaPlugin.setScreenInfoAsync(data);
  }

  Future<void> setLEDColor(Color color) {
    return nimmstaPlugin.setLEDColor(color);
  }

  Future<void> triggerLEDBurst(int repeat, int duration, int pulseDuration,
      Color color) {
    return nimmstaPlugin.triggerLEDBurst(repeat, duration, pulseDuration, color);
  }

  Future<void> triggerVibrationBurst(int repeat, int duration,
      int pulseDuration, int intensity) {
    return nimmstaPlugin.triggerVibrationBurst(repeat, duration, pulseDuration, intensity);
  }

  Future<void> triggerBeeperBurst(int repeat, int duration, int pulseDuration,
      int intensity) {
    return nimmstaPlugin.triggerBeeperBurst(repeat, duration, pulseDuration, intensity);
  }
}

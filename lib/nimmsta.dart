import 'dart:ui';
import 'nimmsta_platform_interface.dart';

/// The Nimmsta Flutter Plugin
class Nimmsta {
  /// Get the instance of the Nimmsta plugin
  final nimmstaPlugin = NimmstaPlatform.instance;

  /// Checks whether a Nimmsta device is currently connected
  Future<bool?> isConnected() {
    return nimmstaPlugin.isConnected();
  }

  /// Establishes a connection with a Nimmsta device.
  Future<void> connect() {
    return nimmstaPlugin.connect();
  }

  /// Re-establishes a connection to a specific Nimmsta device using the given [address].
  Future<void> reconnect(String address) {
    return nimmstaPlugin.reconnect(address);
  }

  /// Disconnects the current connection to the Nimmsta device.
  Future<void> disconnect() {
    return nimmstaPlugin.disconnect();
  }

  /// Sends a [layout] update to the Nimmsta device and updates it with specific [data].
  Future<void> setLayout(String layout, Map<String, String> data) {
    return nimmstaPlugin.setLayout(layout, data);
  }

  /// Updates the screen information on the Nimmsta device asynchronously.
  Future<void> setScreenInfoAsync(Map<String, String> data) {
    return nimmstaPlugin.setScreenInfoAsync(data);
  }

  /// Sets the LED color of the Nimmsta device.
  Future<void> setLEDColor(Color color) {
    return nimmstaPlugin.setLEDColor(color);
  }

  /// Triggers an LED burst that blinks the LED for a specific duration and with specified intervals.
  Future<void> triggerLEDBurst(
      int repeat, int duration, int pulseDuration, Color color) {
    return nimmstaPlugin.triggerLEDBurst(
        repeat, duration, pulseDuration, color);
  }

  /// Triggers a vibration burst on the Nimmsta device.
  Future<void> triggerVibrationBurst(
      int repeat, int duration, int pulseDuration, int intensity) {
    return nimmstaPlugin.triggerVibrationBurst(
        repeat, duration, pulseDuration, intensity);
  }

  /// Triggers a beeper burst for the Nimmsta device.
  Future<void> triggerBeeperBurst(
      int repeat, int duration, int pulseDuration, int intensity) {
    return nimmstaPlugin.triggerBeeperBurst(
        repeat, duration, pulseDuration, intensity);
  }
}

import 'dart:ui';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nimmsta_event.dart';
import 'nimmsta_method_channel.dart';

/// Abstract class that defines the platform interface for the Nimmsta plugin.
/// This acts as the base class for platform-specific implementations, ensuring
/// consistent API usage across different platforms.
abstract class NimmstaPlatform extends PlatformInterface {
  /// Constructor for [NimmstaPlatform], initializing with a [PlatformInterface] token.
  NimmstaPlatform() : super(token: _token);

  static final Object _token = Object();

  static NimmstaPlatform _instance = MethodChannelNimmsta();

  /// Retrieves the current platform interface instance.
  static NimmstaPlatform get instance => _instance;

  static set instance(NimmstaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Checks if the Nimmsta device is currently connected.
  ///
  /// Returns `true` if connected, `false` otherwise, or `null` if unsupported.
  Future<bool?> isConnected() {
    throw UnimplementedError('isConnected() has not been implemented.');
  }

  /// Establishes a connection to the Nimmsta device.
  Future<void> connect() {
    throw UnimplementedError('connect() has not been implemented.');
  }

  /// Attempts to reconnect to the Nimmsta device using its address.
  ///
  /// [address] specifies the unique address of the Nimmsta device.
  Future<void> reconnect(String address) {
    throw UnimplementedError('reconnect() has not been implemented.');
  }

  /// Disconnects from the currently connected Nimmsta device.
  Future<void> disconnect() {
    throw UnimplementedError('disconnect() has not been implemented.');
  }

  /// Configures the screen layout on the Nimmsta device.
  ///
  /// [layout] is the layout identifier.
  /// [data] specifies the key-value mapping for dynamic layout properties.
  Future<void> setLayout(String layout, Map<String, String> data) {
    throw UnimplementedError('setLayout() has not been implemented.');
  }

  /// Updates the screen information asynchronously on the Nimmsta device.
  ///
  /// [data] is a map of key-value pairs representing screen properties.
  Future<void> setScreenInfoAsync(Map<String, String> data) {
    throw UnimplementedError('setScreenInfoAsync() has not been implemented.');
  }

  /// Sets the LED color of the Nimmsta device.
  ///
  /// [color] defines the desired [Color] to set.
  Future<void> setLEDColor(Color color) {
    throw UnimplementedError('setLEDColor() has not been implemented.');
  }

  /// Triggers an LED burst pattern on the Nimmsta device.
  ///
  /// [repeat] specifies the number of bursts.
  /// [duration] is the total duration of the burst sequence in milliseconds.
  /// [pulseDuration] defines the duration of a single pulse.
  /// [color] indicates the color of the LED burst.
  Future<void> triggerLEDBurst(
      int repeat, int duration, int pulseDuration, Color color) {
    throw UnimplementedError('triggerLEDBurst() has not been implemented.');
  }

  /// Triggers a vibration burst pattern on the Nimmsta device.
  ///
  /// [repeat] specifies the number of bursts.
  /// [duration] is the total duration of the burst sequence in milliseconds.
  /// [pulseDuration] defines the duration of a single pulse.
  /// [intensity] represents the vibration intensity.
  Future<void> triggerVibrationBurst(
      int repeat, int duration, int pulseDuration, int intensity) {
    throw UnimplementedError(
        'triggerVibrationBurst() has not been implemented.');
  }

  /// Triggers a beeper burst pattern on the Nimmsta device.
  ///
  /// [repeat] specifies the number of bursts.
  /// [duration] is the total duration of the burst sequence in milliseconds.
  /// [pulseDuration] defines the duration of a single pulse.
  /// [intensity] represents the sound intensity of the beeper.
  Future<void> triggerBeeperBurst(
      int repeat, int duration, int pulseDuration, int intensity) {
    throw UnimplementedError('triggerBeeperBurst() has not been implemented.');
  }

  /// Provides a stream of callback events from the Nimmsta device.
  ///
  /// This stream emits instances of [NimmstaEvent] corresponding to device events.
  Stream<NimmstaEvent> getCallbackStream() {
    throw UnimplementedError('getCallbackStream() has not been implemented.');
  }
}

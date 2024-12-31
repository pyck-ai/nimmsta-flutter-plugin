import 'dart:ui';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nimmsta_event.dart';
import 'nimmsta_method_channel.dart';

abstract class NimmstaPlatform extends PlatformInterface {
  /// Constructs a NimmstaPlatform.
  NimmstaPlatform() : super(token: _token);

  static final Object _token = Object();

  static NimmstaPlatform _instance = MethodChannelNimmsta();

  /// The default instance of [NimmstaPlatform] to use.
  ///
  /// Defaults to [MethodChannelNimmsta].
  static NimmstaPlatform get instance => _instance;

  static set instance(NimmstaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> isConnected() {
    throw UnimplementedError('isConnected() has not been implemented.');
  }

  Future<void> connect() {
    throw UnimplementedError('connect() has not been implemented.');
  }

  Future<void> reconnect(String address) {
    throw UnimplementedError('reconnect() has not been implemented.');
  }

  Future<void> disconnect() {
    throw UnimplementedError('disconnect() has not been implemented.');
  }

  Future<void> setLayout(String layoutResource, Map<String, String> data) {
    throw UnimplementedError('setLayout() has not been implemented.');
  }

  Future<void> setScreenInfoAsync(Map<String, String> data) {
    throw UnimplementedError('setScreenInfoAsync() has not been implemented.');
  }

  Future<void> setLEDColor(Color color) {
    throw UnimplementedError('setLEDColor() has not been implemented.');
  }

  Future<void> triggerLEDBurst(int repeat, int duration, int pulseDuration, Color color) {
    throw UnimplementedError('triggerLEDBurst() has not been implemented.');
  }

  Future<void> triggerVibrationBurst(int repeat, int duration, int pulseDuration, int intensity) {
    throw UnimplementedError('triggerVibrationBurst() has not been implemented.');
  }

  Future<void> triggerBeeperBurst(int repeat, int duration, int pulseDuration, int intensity) {
    throw UnimplementedError('triggerBeeperBurst() has not been implemented.');
  }

  Stream<NimmstaEvent> getCallbackStream() {
    throw UnimplementedError('getCallbackStream() has not been implemented.');
  }
}

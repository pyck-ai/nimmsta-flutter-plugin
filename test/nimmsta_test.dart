import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nimmsta/nimmsta.dart';
import 'package:nimmsta/nimmsta_event.dart';
import 'package:nimmsta/nimmsta_platform_interface.dart';
import 'package:nimmsta/nimmsta_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNimmstaPlatform
    with MockPlatformInterfaceMixin
    implements NimmstaPlatform {
  @override
  Future<bool?> isConnected() => Future.value(false);

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  Stream<NimmstaEvent> getCallbackStream() => Stream.value(NimmstaEvent(
      NimmstaEventType.DID_SCAN_BARCODE, {"barcode": "6939801713458"}));

  @override
  Future<void> reconnect(String address) async {}

  @override
  Future<void> setLEDColor(Color color) async {}

  @override
  Future<void> setLayout(
      String layoutResource, Map<String, String> data) async {}

  @override
  Future<void> setScreenInfoAsync(Map<String, String> data) async {}

  @override
  Future<void> triggerBeeperBurst(
      int repeat, int duration, int pulseDuration, int intensity) async {}

  @override
  Future<void> triggerLEDBurst(
      int repeat, int duration, int pulseDuration, Color color) async {}

  @override
  Future<void> triggerVibrationBurst(
      int repeat, int duration, int pulseDuration, int intensity) async {}
}

void main() {
  final NimmstaPlatform initialPlatform = NimmstaPlatform.instance;

  test('$MethodChannelNimmsta is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNimmsta>());
  });

  test('isConnected', () async {
    Nimmsta nimmstaPlugin = Nimmsta();
    MockNimmstaPlatform fakePlatform = MockNimmstaPlatform();
    NimmstaPlatform.instance = fakePlatform;

    expect(await nimmstaPlugin.isConnected(), false);
  });
}

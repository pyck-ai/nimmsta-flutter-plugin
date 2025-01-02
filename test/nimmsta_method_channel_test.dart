import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nimmsta/nimmsta_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNimmsta platform = MethodChannelNimmsta();
  const MethodChannel channel = MethodChannel('nimmsta/methods');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return false;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('isConnected', () async {
    expect(await platform.isConnected(), false);
  });
}

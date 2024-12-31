<?code-excerpt path-base="example"?>

# nimmsta

[![pub package](https://img.shields.io/pub/v/nimmsta.svg)](https://pub.dev/packages/nimmsta)

A Flutter plugin wrapping the NIMMSTA CORE:Android SDK. The SDK is only available for Android. Please check the NIMMSTA
website for further reference: https://docs.nimmsta.com/core/android/6.0/

|             | Android |
|-------------|---------|
| **Support** | SDK 26+ |

## Example

<?code-excerpt "lib/basic.dart (basic-example)"?>

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:nimmsta/nimmsta.dart';
import 'package:nimmsta/nimmsta_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _nimmstaPlugin = Nimmsta();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _nimmstaPlugin.nimmstaPlugin
        .getCallbackStream()
        .listen((NimmstaEvent event) {
      switch (event.type) {
        case NimmstaEventType.DID_SCAN_BARCODE:
          print("Event: Did scan barcode: ${event.data?["barcode"]}");
          break;
        case NimmstaEventType.DID_CONNECT_AND_INIT:
          print("Event: Did connect and init");
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: TextButton(
            onPressed: () async {
              await _nimmstaPlugin.connect();
            },
            child: Text("Connect")),
      ),
    );
  }
}

```

See the example app for more complex examples.

## Configuration

### Android

Make sure that you follow the configuration steps making it to work. The NIMMSTA SDK is hosted in a private repository.
You have first to request access at NIMMSTA in order to get your personal credentials. After that you have to set the
credentials in `android/local.properties` as follows:
```groovy
nimmsta.username=[your username]
nimmsta.password=[your password]
```

Within `android/app/build.gradle` you have to add the following in the `android` section:
```groovy
android {
    ...
    packagingOptions {
        exclude 'META-INF/*.kotlin_module'
        exclude 'META-INF/DEPENDENCIES'
        exclude 'META-INF/INDEX.LIST'
        exclude 'META-INF/io.netty.versions.properties'
    }
}
```
The SDK uses their own Activities for displaying the connecting functionality including the theme styling. So the `NormalTheme` should look like the following in `android/app/src/main/res/values/styles.xml` and `android/app/src/main/res/values-night/styles.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    ...
    <style name="NormalTheme" parent="Theme.AppCompat.Light.DarkActionBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
```
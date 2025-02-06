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

  final layout = """<?xml version="1.0" encoding="utf-8"?>
<NimmstaLayout name="updating">
    <device width="1.54" height="1.54" pxx="200" pxy="200">
        <screen default="true" name="default">
            <staticElements>
                <cell name="title">Default Title</cell>
                <cell name="subtitle">Default Subtitle</cell>
            </staticElements>
        </screen>
    </device>
</NimmstaLayout>""";

  bool isConnected = false;

  String connectedDevice = "Not Connected";

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
          debugPrint("Event: Did scan barcode: ${event.data?["barcode"]}");
          break;

        case NimmstaEventType.BATTERY_LEVEL_CHANGED:
          debugPrint("Event: Battery level changed");
          break;

        case NimmstaEventType.DID_CLICK_BUTTON:
          debugPrint("Event: Did click button}");
          break;

        case NimmstaEventType.DID_DISCONNECT:
          debugPrint("Event: Did diconnect");

          setState(() {
            isConnected = false;
            connectedDevice = "Not Connected";
          });

          break;

        case NimmstaEventType.DID_CONNECT_AND_INIT:
          debugPrint("Event: Did connect and init");

          setState(() {
            isConnected = true;
            connectedDevice = event.data?["device"];
          });

          break;

        case NimmstaEventType.DID_RECONNECT_AND_INIT:
          debugPrint("Event: Did reconect and init");

          setState(() {
            isConnected = true;
            connectedDevice = event.data?["device"];
          });

          break;

        case NimmstaEventType.DID_RECEIVE_EVENT:
          debugPrint("Event: Did receive event");
          break;

        case NimmstaEventType.DID_TOUCH:
          debugPrint(
              "Event: Did touch x: ${event.data?["x"]} y: ${event.data?["y"]}");
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
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Connected Device: "), Text(connectedDevice)],
              ),
              TextButton(
                  onPressed: () async {
                    bool? isConnected = await _nimmstaPlugin.isConnected();

                    setState(() {
                      this.isConnected = isConnected ?? false;
                    });
                  },
                  child: Text("Is Connected")),
              TextButton(
                  onPressed: () async {
                    await _nimmstaPlugin.connect();
                  },
                  child: Text("Connect")),
              TextButton(
                  onPressed: () async {
                    await _nimmstaPlugin.reconnect("");
                  },
                  child: Text("Reconnect")),
              TextButton(
                  onPressed: isConnected
                      ? () async {
                          await _nimmstaPlugin.disconnect();
                        }
                      : null,
                  child: Text("Disconnect")),
              TextButton(
                  onPressed: isConnected
                      ? () async {
                          await _nimmstaPlugin.setLayout(layout, {});
                        }
                      : null,
                  child: Text("SetLayout")),
              TextButton(
                  onPressed: isConnected
                      ? () async {
                          await _nimmstaPlugin.setScreenInfoAsync(
                              {"title": "Nimmsta Flutter Plugin"});
                        }
                      : null,
                  child: Text("SetScreenInfoAsync")),
              TextButton(
                  onPressed: isConnected
                      ? () async {
                          await _nimmstaPlugin.setLEDColor(Colors.blue);
                        }
                      : null,
                  child: Text("SetLEDColor")),
              TextButton(
                  onPressed: isConnected
                      ? () async {
                          await _nimmstaPlugin.triggerLEDBurst(
                              2, 250, 400, Colors.red);
                        }
                      : null,
                  child: Text("TriggerLEDBurst")),
              TextButton(
                  onPressed: isConnected
                      ? () async {
                          await _nimmstaPlugin.triggerVibrationBurst(
                              3, 500, 250, 100);
                        }
                      : null,
                  child: Text("TriggerVibrationBurst")),
              TextButton(
                  onPressed: isConnected
                      ? () async {
                          await _nimmstaPlugin.triggerBeeperBurst(
                              5, 500, 250, 25);
                        }
                      : null,
                  child: Text("TriggerBeeperBurst"))
            ],
          ),
        ),
      ),
    );
  }
}

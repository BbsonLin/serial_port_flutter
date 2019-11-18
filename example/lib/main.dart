import 'package:flutter/material.dart';

import 'package:serial_port_flutter_example/pages/home.dart';
import 'package:serial_port_flutter_example/pages/setting_baudrate.dart';
import 'package:serial_port_flutter_example/pages/setting_device.dart';
import 'package:serial_port_flutter_example/pages/settings.dart';
import 'package:serial_port_flutter_example/stores/app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      builder: (context) => AppModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Serial Port Example",
      routes: {
        "/setting": (context) => SettingPage(),
        "/setting/device": (context) => SettingDevicePage(),
        "/setting/baudrate": (context) => SettingBaudratePage(),
      },
      home: HomePage(),
    );
  }
}

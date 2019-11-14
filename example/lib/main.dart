import 'package:flutter/material.dart';

import 'package:flutter_serial_port_example/pages/home.dart';
import 'package:flutter_serial_port_example/pages/setting_device.dart';
import 'package:flutter_serial_port_example/pages/settings.dart';
import 'package:flutter_serial_port_example/stores/app.dart';
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
      },
      home: HomePage(),
    );
  }
}

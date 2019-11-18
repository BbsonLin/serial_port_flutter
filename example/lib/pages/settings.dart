import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Device"),
            onTap: () {
              Navigator.of(context).pushNamed("/setting/device");
            },
          ),
          ListTile(
            title: Text("Baudrate"),
            onTap: () {
              Navigator.of(context).pushNamed("/setting/baudrate");
            },
          )
        ],
      ),
    );
  }
}

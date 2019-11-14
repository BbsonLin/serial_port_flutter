import 'package:flutter/material.dart';
import 'package:flutter_serial_port/flutter_serial_port.dart';

class AppModel extends ChangeNotifier {
  Device _device;

  Device get device => _device;

  void updateDevice(Device device) {
    _device = device;
    notifyListeners();
  }
}
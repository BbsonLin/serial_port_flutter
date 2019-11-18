import 'package:flutter/material.dart';
import 'package:serial_port_flutter/serial_port_flutter.dart';

class AppModel extends ChangeNotifier {
  Device _device;
  int _baudrate = 9600;

  Device get device => _device;
  int get baudrate => _baudrate;

  void updateDevice(Device device) {
    _device = device;
    notifyListeners();
  }

  void updateBaudrate(int baudrate) {
    _baudrate = baudrate;
    notifyListeners();
  }
}
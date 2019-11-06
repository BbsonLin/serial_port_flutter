import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FlutterSerialPort {
  static const MethodChannel _channel = const MethodChannel('serial_port');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> listDevice() async {
    String device = await _channel.invokeMethod("getAllDevices");
    return device;
  }

  static Future<List<Device>> listDevices() async {
    List devices = await _channel.invokeMethod("getAllDevices");
    List devicesPath = await _channel.invokeMethod("getAllDevicesPath");

    List<Device> deviceList = List<Device>();
    devices.asMap().forEach((index, deviceName) {
      deviceList.add(Device(deviceName, devicesPath[index]));
    });
    return deviceList;
  }

  static Future createSerialPort(Device device) async {
    return SerialPort(_channel.name, device, 9600);
  }
}

class SerialPort {
  MethodChannel _channel;
  EventChannel _eventChannel;
  Stream _eventStream;
  Device device;
  int baudrate;
  bool _deviceConnected;

  SerialPort(String methodChannelName, Device device, int baudrate) {
    this.device = device;
    this.baudrate = baudrate;
    this._channel = MethodChannel(methodChannelName);
    this._eventChannel = EventChannel("$methodChannelName/event");
    this._deviceConnected = false;
  }

  bool get isConnected => _deviceConnected;

  Stream get receiveStream {
    _eventStream = _eventChannel.receiveBroadcastStream();
    return _eventStream;
  }

  Future<bool> open() async {
    bool openResult = await _channel.invokeMethod(
        "open", {'devicePath': device.path, 'baudrate': baudrate});

    if (openResult) {
      _deviceConnected = true;
    }

    return openResult;
  }

  Future<bool> close() async {
    bool closeResult = await _channel.invokeMethod("close");

    if (closeResult) {
      _deviceConnected = false;
    }

    return closeResult;
  }

  Future<void> write(Uint8List data) async {
    return await _channel.invokeMethod("write", {"data": data});
  }
}

class Device {
  String name;
  String path;

  Device(this.name, this.path);

  @override
  String toString() {
    return "Device($name, $path)";
  }
}

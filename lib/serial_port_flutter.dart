import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

/// 
class FlutterSerialPort {
  static const MethodChannel _channel = const MethodChannel('serial_port');

  /// Default plugin function
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// List all devices
  static Future<List<Device>> listDevices() async {
    List devices = await _channel.invokeMethod("getAllDevices");
    List devicesPath = await _channel.invokeMethod("getAllDevicesPath");

    List<Device> deviceList = List<Device>();
    devices.asMap().forEach((index, deviceName) {
      deviceList.add(Device(deviceName, devicesPath[index]));
    });
    return deviceList;
  }

  /// Create an [SerialPort] instance
  static Future createSerialPort(Device device, int baudrate) async {
    return SerialPort(_channel.name, device, baudrate);
  }
}

/// [SerialPort] instance manage all channels between Android and Flutter, [Device] object.
/// Also provides handy methods, like [open], [close], [write] and [receiveStream].
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

  /// Stream(Event) coming from Android
  Stream<Uint8List> get receiveStream {
    _eventStream = _eventChannel.receiveBroadcastStream().map<Uint8List>((dynamic value) => value);
    return _eventStream;
  }

  @override
  String toString() {
    return "SerialPort($device, $baudrate)";
  }

  /// Open device
  Future<bool> open() async {
    bool openResult = await _channel.invokeMethod(
        "open", {'devicePath': device.path, 'baudrate': baudrate});

    if (openResult) {
      _deviceConnected = true;
    }

    return openResult;
  }

  /// Close device
  Future<bool> close() async {
    bool closeResult = await _channel.invokeMethod("close");

    if (closeResult) {
      _deviceConnected = false;
    }

    return closeResult;
  }

  /// Write data to device
  Future<void> write(Uint8List data) async {
    return await _channel.invokeMethod("write", {"data": data});
  }
}

/// [Device] contains device information(name and path).
class Device {
  String name;
  String path;

  Device(this.name, this.path);

  @override
  String toString() {
    return "Device($name, $path)";
  }
}


A Flutter plugin integrated with [Android-SerialPort-API](https://github.com/licheedev/Android-SerialPort-API).

This plugin works only for Android devices.


## Usage

### List devices

``` dart
Future<List<Device>> findDevices() async {
  return await FlutterSerialPort.listDevices();
}
```

### Create `SerialPort` for certain device

``` dart
Device theDevice = Device("deviceName", "/your/device/path");
int baudrate = 9600;
Serial serialPort = await FlutterSerialPort.createSerialPort(theDevice, baudrate);
```

### Open/Close device

``` dart
bool openResult = await serialPort.open();
print(serialPort.isConnected) // true
bool closeResult = await serialPort.close();
print(serialPort.isConnected) // false
```

### Read/Write data from/to device

``` dart
// Listen to `receiveStream`
serialPort.receiveStream.listen((recv) {
  print("Receive: $recv");
});

serialPort.write(Uint8List.fromList("Write some data".codeUnits));
```

## Example

Check out the [**example**](https://github.com/BbsonLin/serial_port_flutter/blob/master/example/README.md).


## Issues

### Build failed on Android

If you bump into a issue like below.

![](https://raw.githubusercontent.com/BbsonLin/serial_port_flutter/master/doc/images/issue-android-build-failed.png)

Change the `android:label` in `AndroidManifest.xml`.

Check out this commit [fix: 🐛 Fix Android build failed issue](https://github.com/BbsonLin/serial_port_flutter/commit/2ae93ef70b8a5897b47013af890c946da84b827f)

### App crashed on Android x86

This is all about Android permission problem.
Please check out [Issue #4](https://github.com/BbsonLin/serial_port_flutter/issues/4#issuecomment-646545598).

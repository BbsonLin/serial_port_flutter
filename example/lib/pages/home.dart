import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:serial_port_flutter/serial_port_flutter.dart';
import 'package:serial_port_flutter_example/stores/app.dart';
import 'package:serial_port_flutter_example/utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _dataController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  SerialPort _serialPort;
  StreamSubscription _subscription;
  bool isPortOpened = false;
  bool isHexMode = false;
  List<Widget> _historyData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    AppModel store = Provider.of<AppModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Serial Port Example"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed("/setting");
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // Text('Running on: $_platformVersion\n'),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _historyData,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _dataController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Text To Send",
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    children: <Widget>[
                      store.device != null
                          ? Text("${store.device.name} , ${store.device.path}")
                          : Text("Please select device"),
                      Text("Baudrate: ${store.baudrate}"),
                      Row(
                        children: <Widget>[
                          RaisedButton(
                            child: !isPortOpened ? Text("Open") : Text("Close"),
                            onPressed: store.device != null
                                ? () async {
                                    final debounceTransformer =
                                        StreamTransformer<Uint8List,
                                                dynamic>.fromBind(
                                            (s) => s.transform(debounceBuffer(
                                                const Duration(
                                                    milliseconds: 500))));
                                    if (!isPortOpened) {
                                      var serialPort = await FlutterSerialPort
                                          .createSerialPort(store.device, store.baudrate);
                                      bool openResult = await serialPort.open();
                                      setState(() {
                                        _serialPort = serialPort;
                                        isPortOpened = openResult;
                                      });
                                      _subscription = _serialPort.receiveStream
                                          .transform(debounceTransformer)
                                          .listen((recv) {
                                        print("Receive: $recv");
                                        String recvData =
                                            formatReceivedData(recv);
                                        setState(() {
                                          _historyData
                                              .add(Text(">>> $recvData"));
                                        });
                                      });
                                      print("openResult: $openResult");
                                    } else {
                                      bool closeResult =
                                          await _serialPort.close();
                                      setState(() {
                                        _serialPort = null;
                                        isPortOpened = !closeResult;
                                      });
                                      _subscription = null;
                                      print("closeResult: $closeResult");
                                    }
                                  }
                                : null,
                          ),
                          SizedBox(width: 8.0),
                          RaisedButton(
                            child: Text("Send"),
                            onPressed: store.device != null
                                ? () {
                                    var sentData = formatSentData(_dataController.text);
                                    print("Send: $sentData");
                                    _serialPort.write(Uint8List.fromList(sentData));
                                    setState(() {
                                      _historyData.add(Text("<<< ${_dataController.text}"));
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            onChanged: (bool value) {
                              setState(() {
                                isHexMode = value;
                              });
                            },
                            value: isHexMode,
                          ),
                          Text("Hex"),
                          SizedBox(width: 16.0),
                          RaisedButton(
                            child: Text("Clear"),
                            onPressed: () {
                              setState(() {
                                _historyData = [];
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  scrollToBottom() {
    // print("scrollToBottom ${_scrollController.position}");
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  String formatReceivedData(recv) {
    if (isHexMode) {
      return recv
          .map((List<int> char) => char.map((c) => intToHex(c)).join())
          .join();
    } else {
      return recv.map((List<int> char) => String.fromCharCodes(char)).join();
    }
  }

  List<int> formatSentData(String sendStr) {
    if (isHexMode) {
      return hexToUnits(sendStr);
    } else {
      return sendStr.codeUnits;
    }
  }
}

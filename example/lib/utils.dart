List<int> hexToUnits(String hexStr, {int combine=2}) {
  hexStr = hexStr.replaceAll(" ", "");
  List<int> hexUnits = [];
  for(int i = 0;i < hexStr.length;i+=combine) {
    hexUnits.add(hexToInt(hexStr.substring(i, i+combine)));
  }
  return hexUnits;
}

int hexToInt(String hex) {
  print(int.parse(hex, radix: 16));
  return int.parse(hex, radix: 16);
}

String intToHex(int i) {
  return i.toRadixString(16).toUpperCase();
}

/// Convert Hex string to integer list
/// 
/// ``` dart
/// String hexStr = "7EA11200B37E";
/// print(hexToUnits(hexStr)); // [126, 161, 18, 0, 179, 126]
/// ```
List<int> hexToUnits(String hexStr, {int combine=2}) {
  hexStr = hexStr.replaceAll(" ", "");
  List<int> hexUnits = [];
  for(int i = 0;i < hexStr.length;i+=combine) {
    hexUnits.add(hexToInt(hexStr.substring(i, i+combine)));
  }
  return hexUnits;
}

/// Convert Hex string to an single integer value
/// 
/// ``` dart
/// String hexStr = "7E";
/// print(hexToInt(hexStr)); // 126
/// ```
int hexToInt(String hex) {
  return int.parse(hex, radix: 16);
}

/// Convert single integer value to Hex string
/// 
/// ``` dart
/// int hexInt = 126;
/// print(intToHex(hexInt)); // 7E
/// ```
String intToHex(int i, {int pad=2}) {
  return i.toRadixString(16).padLeft(pad, '0').toUpperCase();
}

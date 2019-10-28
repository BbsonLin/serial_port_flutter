#import "FlutterSerialPortPlugin.h"
#import <flutter_serial_port/flutter_serial_port-Swift.h>

@implementation FlutterSerialPortPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSerialPortPlugin registerWithRegistrar:registrar];
}
@end

#import "OcrPlugin.h"
#import <AipOcrSdk.h>
@implementation OcrPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"ocr_plugin"
            binaryMessenger:[registrar messenger]];
  OcrPlugin* instance = [[OcrPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"initOcrSdk" isEqualToString:call.method]){
     result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"init" isEqualToString:call.method]){
      NSString *appkey = call.arguments[@"appKey"];
       NSString *secretKey = call.arguments[@"secretKey"];
      
      [AipOcrService]
      
  }
  
  
  else {
    result(FlutterMethodNotImplemented);
  }
}

@end

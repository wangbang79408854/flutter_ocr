#import "OcrPlugin.h"
#import <AipOcrSdk/AipOcrSdk.h>

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
  }
    // SDK 初始化
  else if ([@"initOcrSdk" isEqualToString:call.method]) {
      NSDictionary *dic = call.arguments;
      
      if ([dic isKindOfClass:[NSDictionary class]]) {
          NSString *key = dic[@"ak"];
          NSString *secret = dic[@"sk"];
          
          [[AipOcrService shardService] authWithAK:key andSK:secret];
          dispatch_async(dispatch_get_main_queue(), ^{
              result(@"true");
          });
      }
  }
    // 普通文字识别
  else if ([@"recognize" isEqualToString:call.method]) {
      NSDictionary *dic = call.arguments;
      
      if ([dic isKindOfClass:[NSDictionary class]]) {
          NSString *filePath = dic[@"filePath"];
          NSString *languageType = dic[@"languageType"];
          
          UIImage *image = [UIImage imageWithContentsOfFile:filePath];
          [[AipOcrService shardService] detectTextBasicFromImage:image withOptions:@{@"language_type": languageType, @"detect_direction": @"true"} successHandler:^(id recognizeResult) {
              NSLog(@"[OcrPlugin] success: %@", recognizeResult);
              NSDictionary *successDic = @{
                                           @"returnCode": @(0),
                                           @"returnMsg": [self getRecognizeStringFromResultObj:recognizeResult]
                                           };
              NSData *jsonData = [NSJSONSerialization dataWithJSONObject:successDic options:0 error:nil];
              NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  result(jsonStr);
              });
          } failHandler:^(NSError *err) {
              NSLog(@"[OcrPlugin] error: %@", err);
              NSDictionary *successDic = @{
                                           @"errorCode": @([err code]),
                                           @"errorMsg": [err localizedDescription]
                                           };
              NSData *jsonData = [NSJSONSerialization dataWithJSONObject:successDic options:0 error:nil];
              NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
              dispatch_async(dispatch_get_main_queue(), ^{
                  result(jsonStr);
              });
          }];
      }
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSString *)getRecognizeStringFromResultObj:(id)resultObj {
    NSMutableString *message = [NSMutableString string];
    
    if(resultObj[@"words_result"]){
        if([resultObj[@"words_result"] isKindOfClass:[NSDictionary class]]){
            [resultObj[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                    [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                }else{
                    [message appendFormat:@"%@: %@\n", key, obj];
                }
            }];
        }else if([resultObj[@"words_result"] isKindOfClass:[NSArray class]]){
            for(NSDictionary *obj in resultObj[@"words_result"]){
                if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                    [message appendFormat:@"%@\n", obj[@"words"]];
                }else{
                    [message appendFormat:@"%@\n", obj];
                }
            }
        }
    }else{
        [message appendFormat:@"%@", resultObj];
    }
    
    return message;
}
@end

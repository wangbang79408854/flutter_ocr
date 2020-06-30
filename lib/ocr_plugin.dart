import 'dart:async';

import 'package:flutter/services.dart';

class OcrPlugin {
  static const MethodChannel _channel = const MethodChannel('ocr_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> initOcrSdk(String ak, String sk) async {
    print("OCRplugin ak=$ak,sk = $sk");
    Map<String, String> params = {'ak': ak, 'sk': sk};
    return await _channel.invokeMethod("initOcrSdk", params);
  }

  static Future<String> recognize(String filepath, String languageType) async {
    print("OCRplugin filepath=$filepath,languageType = $languageType");
    Map<String, String> params = {
      'filePath': filepath,
      'languageType': languageType
    };
    return await _channel.invokeMethod("recognize", params);
  }

  static Future<String> recognizeAccurate(String filepath, String languageType) async {
    print("OCRplugin filepath=$filepath,languageType = $languageType");
    Map<String, String> params = {
      'filePath': filepath,
      'languageType': languageType
    };
    return await _channel.invokeMethod("recognizeAccurate", params);
  }



}

class OcrResult {
  int returnCode; // 当 init 或 recognize 成功时 返回  0   否则返回  -1；
  String returnMsg; // （init 接口回传 token，regonize回传识别结果）
  int errorCode; //当returnCode = -1 时，返回SDK错误码
  String errorMsg; //返回SDK错误信息

}

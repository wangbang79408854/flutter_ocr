# flutter_ocr
flutter 百度OCR插件


# Init
##传入AK，SK  返回 json结果

class OcrResult{
    int returnCode;  // 当 init 或 recognize 成功时 返回  0   否则返回  -1；
    
    String returnMsg; // returnCode  == 0 时，作为业务结果直接返回（init 接口回传 token，regonize回传识别结果）

    int errorCode;   //当returnCode = -1 时，返回SDK错误码
    String errorMsg; //返回SDK错误信息

}
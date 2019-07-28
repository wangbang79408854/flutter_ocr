package com.nova.plugins.ocr_plugin;

public class OcrResult {
    private int returnCode; // 当 init 或 recognize 成功时 返回  0   否则返回  -1；
    private String returnMsg; // （init 接口回传 token，regonize回传识别结果）
    private int errorCode; //当returnCode = -1 时，返回SDK错误码
    private String errorMsg; //返回SDK错误信息

    public int getReturnCode() {
        return returnCode;
    }

    public void setReturnCode(int returnCode) {
        this.returnCode = returnCode;
    }

    public String getReturnMsg() {
        return returnMsg;
    }

    public void setReturnMsg(String returnMsg) {
        this.returnMsg = returnMsg;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }
}



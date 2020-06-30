package com.nova.plugins.ocr_plugin;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.AccessToken;
import com.baidu.ocr.sdk.model.GeneralBasicParams;
import com.baidu.ocr.sdk.model.GeneralResult;
import com.baidu.ocr.sdk.model.WordSimple;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class OcrDelegate implements PluginRegistry.ActivityResultListener {

    private final String OCRTag = "OcrDelegate";

    private final Activity activity;

    private final int SUCCESS = 0;

    private final int ERROR = -1;


    public OcrDelegate(Activity activity) {
        this.activity = activity;
    }

    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        return false;
    }

    public void init(final MethodCall call, final MethodChannel.Result methodResult) {
        String AK = call.argument("ak");
        String SK = call.argument("sk");
        Log.d(OCRTag, "ak=" + AK + "sk=" + SK);
        if (activity == null) methodResult.error("contextError", "eroor", "error");

        Log.d(OCRTag, "activityName = " + activity.getComponentName());
        OCR.getInstance(activity).initAccessTokenWithAkSk(new OnResultListener<AccessToken>() {
            @Override
            public void onResult(final AccessToken result) {
                // 调用成功，返回AccessToken对象
//                String token = result.getAccessToken();
                String accessToken = result.getAccessToken();
                Log.d(OCRTag, "accesstoken=" + accessToken);
                methodResult.success(accessToken);
            }

            @Override
            public void onError(OCRError error) {
                // 调用失败，返回OCRError子类SDKError对象
                String message = error.getMessage();
                Log.d("OCRTag", "cause=" + message + error.getErrorCode());
                methodResult.error("errorCode", "init 错误", error.getErrorCode());
                return;
            }
        }, activity.getApplicationContext(), AK, SK);

    }

    public void recognize(final MethodCall call, final MethodChannel.Result result) {
// 通用文字识别参数设置
        String filePath = call.argument("filePath");
        String languageType = call.argument("languagetype");
        if (filePath == null) {
            result.error("filepath", "filepath ==null", 0);
            return;
        }
//        CHN_ENG、ENG、POR、FRE、GER、ITA、SPA、RUS、JAP
        GeneralBasicParams param = new GeneralBasicParams();
        param.setDetectDirection(true);
        param.setLanguageType(languageType);
        param.setDetectDirection(true);
        param.setImageFile(new File(filePath));
        final OcrResult ocrResult = new OcrResult();
        // 调用通用文字识别服务
        OCR.getInstance(activity).recognizeGeneralBasic(param, new OnResultListener<GeneralResult>() {
            @Override
            public void onResult(final GeneralResult generalResult) {
                StringBuilder sb = new StringBuilder();
                for (WordSimple WordSimple : generalResult.getWordList()) {
                    sb.append(WordSimple.getWords());
                    sb.append("\n");
                }
                //创建JSONObject
                try {
                    JSONObject jsonObject = new JSONObject();
                    //键值对赋值
                    jsonObject.put("returnCode", SUCCESS);
                    jsonObject.put("returnMsg", sb.toString());
                    //转化成json字符串
                    String json = jsonObject.toString();
                    result.success(json);
                } catch (JSONException e) {
                    result.error("json error", "转换json错误", null);
                }

            }

            @Override
            public void onError(OCRError error) {
                //创建JSONObject
                try {
                    JSONObject jsonObject = new JSONObject();
                    //键值对赋值
                    jsonObject.put("returnCode", ERROR);
                    jsonObject.put("returnMsg", "SDKERROR");
                    jsonObject.put("errorCode", error.getErrorCode());
                    jsonObject.put("errorMsg", error.getMessage());
                    //转化成json字符串
                    String json = jsonObject.toString();
                    result.success(json);
                } catch (JSONException e) {
                    result.error("json error", "转换json错误", null);
                }
            }
        });
    }

    public void recognizeAccurate(final MethodCall call, final MethodChannel.Result result) {
        // 通用文字识别参数设置
        String filePath = call.argument("filePath");
        String languageType = call.argument("languagetype");
        if (filePath == null) {
            result.error("filepath", "filepath ==null", 0);
            return;
        }
//        CHN_ENG、ENG、POR、FRE、GER、ITA、SPA、RUS、JAP
        GeneralBasicParams param = new GeneralBasicParams();
        param.setDetectDirection(true);
        param.setLanguageType(languageType);
        param.setDetectDirection(true);
        param.setImageFile(new File(filePath));
        final OcrResult ocrResult = new OcrResult();
        // 调用通用文字识别服务

        OCR.getInstance(activity).recognizeAccurateBasic(param, new OnResultListener<GeneralResult>() {
            @Override
            public void onResult(GeneralResult generalResult) {
                StringBuilder sb = new StringBuilder();
                for (WordSimple WordSimple : generalResult.getWordList()) {
                    sb.append(WordSimple.getWords());
                    sb.append("\n");
                }
                //创建JSONObject
                try {
                    JSONObject jsonObject = new JSONObject();
                    //键值对赋值
                    jsonObject.put("returnCode", SUCCESS);
                    jsonObject.put("returnMsg", sb.toString());
                    //转化成json字符串
                    String json = jsonObject.toString();
                    result.success(json);
                } catch (JSONException e) {
                    result.error("json error", "转换json错误", null);
                }

            }

            @Override
            public void onError(OCRError error) {
                try {
                    JSONObject jsonObject = new JSONObject();
                    //键值对赋值
                    jsonObject.put("returnCode", ERROR);
                    jsonObject.put("returnMsg", "SDKERROR");
                    jsonObject.put("errorCode", error.getErrorCode());
                    jsonObject.put("errorMsg", error.getMessage());
                    //转化成json字符串
                    String json = jsonObject.toString();
                    result.success(json);
                } catch (JSONException e) {
                    result.error("json error", "转换json错误", null);
                }
            }
        });


    }


}

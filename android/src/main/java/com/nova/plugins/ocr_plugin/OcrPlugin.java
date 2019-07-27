package com.nova.plugins.ocr_plugin;

import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * OcrPlugin
 */
public class OcrPlugin implements MethodCallHandler {

    private static final String Init = "initOcrSdk";
    private static final String Recognize = "recognize";

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        if (registrar.activity() == null) {
            return;
        }
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "ocr_plugin");
        final OcrDelegate ocrDelegate = new OcrDelegate(registrar.activity());
        registrar.addActivityResultListener(ocrDelegate);
        channel.setMethodCallHandler(new OcrPlugin(registrar, ocrDelegate));
    }


    private final PluginRegistry.Registrar registrar;
    private OcrDelegate delegate;

    public OcrPlugin(final Registrar registrar, final OcrDelegate delegate) {
        this.registrar = registrar;
        this.delegate = delegate;
    }

    @Override
    public void onMethodCall(MethodCall call, Result originResult) {

        if (registrar.activity() == null) {
            originResult.error("no_activity", "Ocr plugin requires a foregroup activity", null);
            return;
        }


        MethodChannel.Result result = new MethodResultWrapper(originResult);

        switch (call.method) {
            case Init:
                delegate.init(call,result);
                break;
            case Recognize:
                delegate.recognize(call,result);
                break;

            default:
                throw new IllegalArgumentException("Unkown operation" + call.method);

        }

    }

    private static class MethodResultWrapper implements MethodChannel.Result {

        private MethodChannel.Result methodResult;
        private Handler handler;


        public MethodResultWrapper(Result methodResult) {
            this.methodResult = methodResult;
            this.handler = new Handler(Looper.getMainLooper());
        }

        @Override
        public void success(final Object result) {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    methodResult.success(result);
                }
            });
        }

        @Override
        public void error(final String s, final String s1, final Object o) {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    methodResult.error(s, s1, o);
                }
            });
        }

        @Override
        public void notImplemented() {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    methodResult.notImplemented();
                }
            });
        }
    }
}

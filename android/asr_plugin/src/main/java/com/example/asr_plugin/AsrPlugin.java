package com.example.asr_plugin;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.util.Log;

import java.util.ArrayList;
import java.util.Map;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.embedding.engine.FlutterEngine;

public class AsrPlugin implements MethodChannel.MethodCallHandler{
    private final static String TAG = "AsrPlugin";
    private final Activity activity;
    private ResultStateful resultStateful;
    private AsrManager asrManager;

//    public static void registerWith(PluginRegistry.Registrar registrar){
//        MethodChannel channel = new MethodChannel(registrar.messenger(),"asr_plugin");
//        AsrPlugin instance=new AsrPlugin(registrar);
//        channel.setMethodCallHandler(instance);
//    }
//
//    public AsrPlugin(PluginRegistry.Registrar registrar){
//        this.activity=registrar.activity();
//    }


    public static void registerWith(FlutterEngine flutterEngine,Activity activity){
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(),"asr_plugin");
        AsrPlugin instance=new AsrPlugin(activity);
        channel.setMethodCallHandler(instance);
    }

    public AsrPlugin(Activity activity){
        this.activity=activity;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if(this.activity ==null){
            Log.e(TAG,"activitiy是空的，有错误");

        }
//        Log.i(TAG,"权限问题？？？");
        initPermission();
//        Log.i(TAG,"不是权限问题");
        switch (methodCall.method){
            case "start":
                resultStateful = ResultStateful.of(result);
                start(methodCall,resultStateful);
                break;
            case "stop":
                stop(methodCall,result);
                break;
            case "cancel":
                cancel(methodCall,result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void start(MethodCall call,ResultStateful result){
        if(activity ==null){
//            Log.e(TAG,"有错误");
            Log.e(TAG,"ignored start,current activity is null");
            result.error("ignored start,current activity is null",null,null);
            return;
        }
        if(getAsrManager()!=null){
//            Log.i(TAG,"测试sdjhsdjhsd");
            getAsrManager().start(call.arguments instanceof Map ? (Map) call.arguments : null);
        } else {
//            Log.i(TAG,"错误监控死角手机号");
            Log.e(TAG,"ignored start,current activity is null");
            result.error("ignored start,current activity is null",null,null);
        }
    }

    private void stop(MethodCall call,MethodChannel.Result result){
        if(asrManager !=null){
            asrManager.stop();
        }
    }

    private void cancel(MethodCall call,MethodChannel.Result result){
        if(asrManager !=null){
            asrManager.cancel();
        }
    }
    /**
     * android 6.0 以上需要动态申请权限
     */
    private void initPermission() {
//        Log.i(TAG,"权限问题11111？？？");
        String permissions[] = {Manifest.permission.RECORD_AUDIO,
                Manifest.permission.ACCESS_NETWORK_STATE,
                Manifest.permission.INTERNET,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
        };

        ArrayList<String> toApplyList = new ArrayList<String>();

        for (String perm :permissions){
            if (PackageManager.PERMISSION_GRANTED != ContextCompat.checkSelfPermission(this.activity, perm)) {
//                Log.i(TAG,"权限问题2222？？？");
                toApplyList.add(perm);
                //进入到这里代表没有权限.

            }
        }
//        Log.i(TAG,"权限问题333？？？");
        String tmpList[] = new String[toApplyList.size()];
        if (!toApplyList.isEmpty()){
            ActivityCompat.requestPermissions(activity, toApplyList.toArray(tmpList), 123);
        }

    }
    @Nullable
    private AsrManager getAsrManager(){
        if(asrManager==null){
            if(activity!=null&&!activity.isFinishing()){
                asrManager = new AsrManager(activity,onAsrListener);
            }
        }
        return asrManager;
    }
    private OnAsrListener onAsrListener = new OnAsrListener(){
        @Override
        public void onAsrReady() {

        }

        @Override
        public void onAsrBegin() {

        }

        @Override
        public void onAsrEnd() {

        }


        @Override
        public void onAsrPartialResult(String[] results, RecogResult recogResult) {

        }
        @Override
        public void onAsrOnlineNluResult(String nluResult) {

        }
        @Override
        public void onAsrFinalResult(String[] results, RecogResult recogResult){
            if(resultStateful !=null){
                resultStateful.success(results[0]);
            }
        }
        @Override
        public void onAsrFinish(RecogResult recogResult) {

        }
        @Override
        public void onAsrFinishError(int errorCode, int subErrorCode, String descMessage,
                              RecogResult recogResult){
            if(resultStateful !=null){
                resultStateful.error(descMessage,null,null);
            }
        }

        @Override
        public void onAsrLongFinish() {

        }

        @Override
        public void onAsrVolume(int volumePercent, int volume) {

        }

        @Override
        public void onAsrAudio(byte[] data, int offset, int length) {

        }

        @Override
        public void onAsrExit() {

        }

        @Override
        public void onOfflineLoaded() {

        }

        @Override
        public void onOfflineUnLoaded() {

        }

    };
}
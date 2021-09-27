package com.dingdangdata.cheguanjia.app

import android.os.Bundle
import com.example.asr_plugin.AsrPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.app.Activity

import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull





//class MainActivity : FlutterActivity(),ActivityAware {
//    private var _activity:Activity?=null
////    override fun onCreate(savedInstanceState: Bundle?) {
////        super.onCreate(savedInstanceState);
////        var FlutterEngineObj = FlutterEngine(this);
////        GeneratedPluginRegistrant.registerWith(FlutterEngineObj);
////        var ShimPluginRegistry1 = ShimPluginRegistry(FlutterEngineObj);
////        AsrPlugin.registerWith(ShimPluginRegistry1.registrarFor("com.example.asr_plugin.AsrPlugin"));
////
////    }
//    override fun configureFlutterEngine(@NonNull flutterEngine:FlutterEngine){
//        GeneratedPluginRegistrant.registerWith(flutterEngine);
//        AsrPlugin.registerWith(flutterEngine,_activity);
//    }
//
//
//    override fun onReattachedToActivityForConfigChanges(binding:ActivityPluginBinding){
//        _activity = binding.activity;
//    }
//
//    override fun onDetachedFromActivity() {
//        TODO("Not yet implemented")
//    }
//
//
//    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//        _activity = binding.activity
//    }
//
//    override fun onDetachedFromActivityForConfigChanges() {
//        TODO("Not yet implemented")
//    }
//}


class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine:FlutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        AsrPlugin.registerWith(flutterEngine,this);
    }

}
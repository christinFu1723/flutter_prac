package com.example.demo7_pro

import android.os.Bundle
import com.example.asr_plugin.AsrPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry

//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity() {
//}




class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState);
        var FlutterEngineObj = FlutterEngine(this);
        GeneratedPluginRegistrant.registerWith(FlutterEngineObj);
        var ShimPluginRegistry1 = ShimPluginRegistry(FlutterEngineObj);
        AsrPlugin.registerWith(ShimPluginRegistry1.registrarFor("com.example.asr_plugin.AsrPlugin"));

    }


}
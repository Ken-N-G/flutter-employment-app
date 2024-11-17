package com.example.employer_lowongan_kita

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example/api_level"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getApiLevel") {
                val apiLevel = getApiLevel()
                result.success(apiLevel)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getApiLevel(): Int {
        return Build.VERSION.SDK_INT
    }
}

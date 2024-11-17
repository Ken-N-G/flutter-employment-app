import 'package:flutter/services.dart';

class AndroidAPILevelChecker {
  static const platform = MethodChannel('com.example/api_level');

  static Future<int?> getApiLevel() async {
    try {
      final int apiLevel = await platform.invokeMethod('getApiLevel');
      return apiLevel;
    } on PlatformException catch (e) {
      print("Failed to get API level: '${e.message}'.");
      return null;
    }
  }
}
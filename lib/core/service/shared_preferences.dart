import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception('AppPreferences not initialized. Call init() first.');
    }
    return _prefs!;
  }

  static String exportToJson() {
    final Map<String, dynamic> prefsMap = {};
    for (String key in instance.getKeys()) {
      prefsMap[key] = instance.get(key);
    }
    return jsonEncode(prefsMap);
  }

  static Future<void> importFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> prefsMap = jsonDecode(jsonString);
      for (var entry in prefsMap.entries) {
        switch (entry.value) {
          case bool value:
            await instance.setBool(entry.key, value);
            break;
          case String value:
            await instance.setString(entry.key, value);
            break;
          case int value:
            await instance.setInt(entry.key, value);
            break;
          case double value:
            await instance.setDouble(entry.key, value);
            break;
          case List value:
            await instance.setStringList(entry.key, value.cast<String>());
            break;
          default:
            break;
        }
      }
    } catch (e) {
      debugPrint('Error importing preferences: $e');
    }
  }
}

import 'package:demo7_pro/utils/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 数据类型
enum PrefsType {
  string,
  stringList,
  int,
  double,
  bool,
}

// 本地持久化存储
class PrefersUtil {
  PrefersUtil._();

  /// 获取持久化存储内容
  /// .e.g PrefersUtil.get('username')
  /// .e.g PrefersUtil.get('enableAutoTheme', init: false)
  static Future<dynamic> get(
    String key, {
    dynamic init,
    PrefsType type: PrefsType.string,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      dynamic result;

      switch (type) {
        case PrefsType.stringList:
          result = prefs.getStringList(key) ?? init;
          break;
        case PrefsType.int:
          result = prefs.getInt(key) ?? init;
          break;
        case PrefsType.double:
          result = prefs.getDouble(key) ?? init;
          break;
        case PrefsType.bool:
          result = prefs.getBool(key) ?? init;
          break;
        case PrefsType.string:
          result = prefs.getString(key) ?? init;
          break;
      }

      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  /// 设置持久化存储内容
  static Future<dynamic> set(String key, dynamic value,
      {PrefsType type: PrefsType.string}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool result;

      if (value == null) return;

      switch (type) {
        case PrefsType.string:
          assert(value is String);
          result = await prefs.setString(key, value);
          break;
        case PrefsType.stringList:
          assert(value is List<String>);
          result = await prefs.setStringList(key, value);
          break;
        case PrefsType.int:
          assert(value is int);
          result = await prefs.setInt(key, value);
          break;
        case PrefsType.double:
          assert(value is double);
          result = await prefs.setDouble(key, value);
          break;
        case PrefsType.bool:
          assert(value is bool);
          result = await prefs.setBool(key, value);
          break;
      }

      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// 删除指定的 key
  static Future<bool> remove(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.remove(key);
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  ///  清空持久化存储内容
  ///  .e.g PrefersUtil.clear();
  static Future<dynamic> clear() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.clear();
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  /// 清除 key 为指定指定字符开头的条目
  static Future<void> clearWithStart(String start) async {
    if (StringUtil.isEmpty(start)) return true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> keys = prefs.getKeys().toList();

      keys = keys.where((key) => key.startsWith(start)).toList();

      if (keys == null || keys.isEmpty) return true;

      Iterable<Future<String>> c = keys.map((key) async {
        await prefs.remove(key);
        return key;
      });

      await Future.wait(c);

      return true;
    } catch (e) {
      throw e.toString();
    }
  }
}

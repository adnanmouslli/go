import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;

  // مفاتيح التخزين الرئيسية
  static const String userDataKey = 'user_data';
  static const String tokenKey = 'token';

  // Singleton pattern
  static MyServices get instance => Get.find<MyServices>();

  Future<MyServices> init() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      return this;
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
      rethrow;
    }
  }

  // حفظ بيانات المستخدم
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      // تحويل البيانات إلى JSON string
      final userDataJson = jsonEncode(userData);

      // حفظ البيانات
      final result =
          await sharedPreferences.setString(userDataKey, userDataJson);
      return result;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  // استرجاع بيانات المستخدم
  Map<String, dynamic>? getUserData() {
    try {
      final userDataJson = sharedPreferences.getString(userDataKey);
      if (userDataJson == null) return null;

      final userData = jsonDecode(userDataJson) as Map<String, dynamic>;

      return userData;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // إدارة التوكن
  Future<bool> setToken(String token) async {
    return await sharedPreferences.setString(tokenKey, token);
  }

  String? getToken() {
    return sharedPreferences.getString(tokenKey);
  }

  Future<bool> removeToken() async {
    return await sharedPreferences.remove(tokenKey);
  }

  // التحقق من وجود المستخدم
  bool isUserLoggedIn() {
    return sharedPreferences.containsKey(userDataKey) &&
        sharedPreferences.containsKey(tokenKey);
  }

  // تحديث بيانات المستخدم الحالي
  Future<bool> updateUserData(Map<String, dynamic> newData) async {
    try {
      var currentData = getUserData();
      if (currentData == null) return false;

      currentData.addAll(newData);
      return await saveUserData(currentData);
    } catch (e) {
      print('Error updating user data: $e');
      return false;
    }
  }

  // حذف بيانات المستخدم
  Future<bool> clearUserData() async {
    try {
      final results = await Future.wait([
        sharedPreferences.remove(userDataKey),
        sharedPreferences.remove(tokenKey),
      ]);
      return results.every((result) => result);
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }

  // استرجاع قيمة محددة من بيانات المستخدم
  T? getUserValue<T>(String key) {
    try {
      final userData = getUserData();
      if (userData == null) return null;
      return userData[key] as T?;
    } catch (e) {
      print('Error getting user value: $e');
      return null;
    }
  }

  // إضافة دالة لحفظ البيانات حسب نوعها
  Future<bool> saveData<T>(String key, T value) async {
    try {
      switch (T) {
        case String:
          return await sharedPreferences.setString(key, value as String);
        case int:
          return await sharedPreferences.setInt(key, value as int);
        case bool:
          return await sharedPreferences.setBool(key, value as bool);
        case double:
          return await sharedPreferences.setDouble(key, value as double);
        case List:
          if (value is List<String>) {
            return await sharedPreferences.setStringList(key, value);
          }
          // للقوائم الأخرى، نقوم بتحويلها إلى JSON
          return await sharedPreferences.setString(key, jsonEncode(value));
        default:
          // للكائنات المعقدة، نقوم بتحويلها إلى JSON
          return await sharedPreferences.setString(key, jsonEncode(value));
      }
    } catch (e) {
      print('Error saving data: $e');
      return false;
    }
  }

// دالة لاسترجاع البيانات حسب نوعها
  T? getData<T>(String key) {
    try {
      final value = sharedPreferences.get(key);
      if (value == null) return null;

      switch (T) {
        case String:
          return value as T;
        case int:
          return value as T;
        case bool:
          return value as T;
        case double:
          return value as T;
        case List:
          if (value is List<String>) {
            return value as T;
          }
          // للقوائم الأخرى، نقوم بتحويلها من JSON
          return jsonDecode(value as String) as T;
        default:
          // للكائنات المعقدة، نقوم بتحويلها من JSON
          return jsonDecode(value as String) as T;
      }
    } catch (e) {
      print('Error getting data: $e');
      return null;
    }
  }

  Future<bool> removeData(String key) async {
    return await sharedPreferences.remove(key);
  }
}

Future<void> initialServices() async {
  try {
    await Get.putAsync(() => MyServices().init(), permanent: true);


    print('Services initialized successfully');
  } catch (e) {
    print('Error initializing services: $e');
  }
}

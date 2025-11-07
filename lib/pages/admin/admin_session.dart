import 'dart:convert';
import 'package:dio/dio.dart';
import '../../config.dart';

class AdminSession {
  static late Dio _dio;

  static Map<String, dynamic>? _user;

  static Future<void> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  /// Gọi API login, không cần session
  static Future<bool> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/login',
        data: jsonEncode({"email": email, "password": password}),
      );

      if (res.statusCode == 200 && res.data["success"] == true) {
        _user = res.data["user"];
        return true;
      }
    } catch (e) {
      print("❌ login error: $e");
    }
    return false;
  }

  static Map<String, dynamic>? currentUser() => _user;
  static bool isLoggedIn() => _user != null;
  static bool isAdmin() => _user?['role'] == 'admin';
}


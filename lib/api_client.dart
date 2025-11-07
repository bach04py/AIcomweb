import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import '../config.dart';

/// =============================================================
/// 🌐 API Client — Dùng cho kết nối Flask backend
/// -------------------------------------------------------------
/// ✅ Hỗ trợ web (in-memory cookie)
/// ✅ Hỗ trợ desktop/mobile (PersistCookieJar)
/// ✅ Có log + xử lý lỗi chi tiết
/// =============================================================
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;
  CookieJar? cookieJar;

  factory ApiClient() => _instance;
  ApiClient._internal();

  /// =============================================================
  /// ⚙️ Khởi tạo Dio + CookieJar
  /// Gọi 1 lần khi app start → await ApiClient().init();
  /// =============================================================
  Future<void> init() async {
    try {
      if (kIsWeb) {
        cookieJar = CookieJar(); // Dành cho Flutter Web
      } else {
        final dir = await getApplicationDocumentsDirectory();
        cookieJar = PersistCookieJar(storage: FileStorage('${dir.path}/.cookies/'));
      }

      dio = Dio(BaseOptions(
        baseUrl: AppConfig.apiBaseUrl, // vd: http://127.0.0.1:5000/api
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      dio.interceptors.add(CookieManager(cookieJar!));

      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra['withCredentials'] = true;
          options.headers['Access-Control-Allow-Credentials'] = true;
          print("➡️ [${options.method}] ${options.uri}");
          return handler.next(options);
        },
        onResponse: (res, handler) {
          print("✅ [${res.statusCode}] ${res.realUri}");
          return handler.next(res);
        },
        onError: (err, handler) {
          print("❌ [${err.response?.statusCode ?? 'ERR'}] ${err.message}");
          return handler.next(err);
        },
      ));
    } catch (e) {
      print("❌ ApiClient.init error: $e");
    }
  }

  // =============================================================
  // 🔐 AUTH
  // =============================================================
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final res = await dio.post(
        '/login',
        data: {'email': email, 'password': password},
        options: Options(extra: {'withCredentials': true}),
      );
      if (res.statusCode == 200) {
        print("✅ login success: ${res.data}");
        return Map<String, dynamic>.from(res.data ?? {});
      }
    } catch (e) {
      print("❌ login error: $e");
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await dio.post('/logout', options: Options(extra: {'withCredentials': true}));
    } catch (e) {
      print("❌ logout error: $e");
    }
  }

  // =============================================================
  // 📰 POSTS CRUD
  // =============================================================

  /// 📦 Lấy danh sách bài viết
  Future<List<dynamic>> getPosts({String? category}) async {
    try {
      final path = category == null ? '/posts' : '/posts?category=${Uri.encodeComponent(category)}';
      final res = await dio.get(path, options: Options(extra: {'withCredentials': true}));
      if (res.statusCode == 200) {
        return List<dynamic>.from(res.data ?? []);
      }
    } catch (e) {
      print("❌ getPosts error: $e");
    }
    return [];
  }

  /// 🆕 Tạo bài viết mới
  Future<bool> createPost(Map<String, dynamic> post) async {
    try {
      final res = await dio.post(
        '/posts/add',
        data: post,
        options: Options(extra: {'withCredentials': true}),
      );

      final data = res.data;
      final ok = (res.statusCode == 200 || res.statusCode == 201) &&
          (data == null || data['success'] == true);
      if (ok) {
        print("🆕 createPost success: ${post['title']}");
        return true;
      } else {
        print("⚠️ createPost failed: ${res.data}");
      }
    } catch (e) {
      print("❌ createPost error: $e");
    }
    return false;
  }

  /// ✏️ Cập nhật bài viết
  Future<bool> updatePost(Map<String, dynamic> post) async {
    try {
      final id = post['id'];
      if (id == null) {
        print("⚠️ updatePost: missing id");
        return false;
      }

      final res = await dio.put(
        '/posts/update/$id',
        data: post,
        options: Options(extra: {'withCredentials': true}),
      );

      final data = res.data;
      final ok = (res.statusCode == 200) && (data == null || data['success'] == true);
      if (ok) {
        print("✏️ updatePost success: $id");
        return true;
      } else {
        print("⚠️ updatePost failed: ${res.data}");
      }
    } catch (e) {
      print("❌ updatePost error: $e");
    }
    return false;
  }

  /// 🗑️ Xóa bài viết
  Future<bool> deletePost(String id) async {
    try {
      final res = await dio.delete('/posts/delete/$id', options: Options(extra: {'withCredentials': true}));
      final data = res.data;
      final ok = (res.statusCode == 200) && (data == null || data['success'] == true);
      if (ok) {
        print("🗑️ deletePost success: $id");
        return true;
      } else {
        print("⚠️ deletePost failed: ${res.data}");
      }
    } catch (e) {
      print("❌ deletePost error: $e");
    }
    return false;
  }

  // =============================================================
  // 📤 UPLOAD FILE (ảnh, video)
  // =============================================================
  Future<String?> uploadFile(Uint8List bytes, String filename) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      });

      final res = await dio.post(
        '/upload',
        data: formData,
        options: Options(extra: {'withCredentials': true}),
      );

      if (res.statusCode == 200) {
        final data = res.data;
        if (data is Map && data.containsKey('url')) {
          print("📸 upload success: ${data['url']}");
          return data['url'];
        }
      }
    } catch (e) {
      print("❌ uploadFile error: $e");
    }
    return null;
  }
}


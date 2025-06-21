import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import '../utils/constants.dart';
import '../models/ai_conversation_model.dart';
import '../models/module_model.dart';
import '../models/theme_model.dart';
import '../models/article_model.dart';

class ApiService extends GetxService {
  late GetConnect _httpClient;

  @override
  void onInit() {
    super.onInit();
    _initHttpClient();
  }

  void _initHttpClient() {
    _httpClient = GetConnect(
      timeout: const Duration(seconds: 30),
      userAgent: 'RussTili/1.0.0',
    );

    _httpClient.baseUrl = AppConstants.baseUrl;

    // Request interceptor
    _httpClient.httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      return request;
    });

    // Response interceptor
    _httpClient.httpClient.addResponseModifier((request, response) {
      if (response.statusCode != null && response.statusCode! >= 400) {
        print('API Error: ${response.statusCode} - ${response.bodyString}');
      }
      return response;
    });
  }

  // AI Chat methods
  Future<ApiResponse<String>> sendMessageToAI(String message, {String? context}) async {
    try {
      final body = {
        'message': message,
        'context': context,
        'language': 'ru',
        'user_language': 'uz',
      };

      final response = await _httpClient.post(
        AppConstants.aiChatUrl,
        body,
      );

      if (response.isOk && response.body != null) {
        final data = response.body as Map<String, dynamic>;
        return ApiResponse.success(data['response'] ?? '');
      } else {
        return ApiResponse.error(_getErrorMessage(response));
      }
    } catch (e) {
      return ApiResponse.error('Internet aloqasi yo\'q: $e');
    }
  }

  // Voice methods
  Future<ApiResponse<String>> textToSpeech(String text) async {
    try {
      final body = {
        'text': text,
        'language': 'ru-RU',
        'voice': 'female',
        'speed': 0.8,
      };

      final response = await _httpClient.post(
        '${AppConstants.voiceUrl}/tts',
        body,
      );

      if (response.isOk && response.body != null) {
        final data = response.body as Map<String, dynamic>;
        return ApiResponse.success(data['audio_url'] ?? '');
      } else {
        return ApiResponse.error(_getErrorMessage(response));
      }
    } catch (e) {
      return ApiResponse.error('Ovozli javob olishda xatolik: $e');
    }
  }

  Future<ApiResponse<String>> speechToText(String audioPath) async {
    try {
      final audioFile = File(audioPath);
      if (!await audioFile.exists()) {
        return ApiResponse.error('Audio fayl topilmadi');
      }

      final form = FormData({
        'audio': MultipartFile(audioFile, filename: 'speech.wav'),
        'language': 'ru-RU',
      });

      final response = await _httpClient.post(
        '${AppConstants.voiceUrl}/stt',
        form,
      );

      if (response.isOk && response.body != null) {
        final data = response.body as Map<String, dynamic>;
        return ApiResponse.success(data['text'] ?? '');
      } else {
        return ApiResponse.error(_getErrorMessage(response));
      }
    } catch (e) {
      return ApiResponse.error('Ovozni matnga aylantiriishda xatolik: $e');
    }
  }

  // Content methods (for future use when backend is ready)
  Future<ApiResponse<List<ModuleModel>>> getModules() async {
    try {
      final response = await _httpClient.get('/modules');

      if (response.isOk && response.body != null) {
        final List<dynamic> data = response.body['modules'];
        final modules = data.map((json) => ModuleModel.fromJson(json)).toList();
        return ApiResponse.success(modules);
      } else {
        return ApiResponse.error(_getErrorMessage(response));
      }
    } catch (e) {
      return ApiResponse.error('Modullarni yuklashda xatolik: $e');
    }
  }

  Future<ApiResponse<List<ThemeModel>>> getThemes(String moduleId) async {
    try {
      final response = await _httpClient.get('/modules/$moduleId/themes');

      if (response.isOk && response.body != null) {
        final List<dynamic> data = response.body['themes'];
        final themes = data.map((json) => ThemeModel.fromJson(json)).toList();
        return ApiResponse.success(themes);
      } else {
        return ApiResponse.error(_getErrorMessage(response));
      }
    } catch (e) {
      return ApiResponse.error('Mavzularni yuklashda xatolik: $e');
    }
  }

  Future<ApiResponse<ArticleModel>> getArticle(String articleId) async {
    try {
      final response = await _httpClient.get('/articles/$articleId');

      if (response.isOk && response.body != null) {
        final article = ArticleModel.fromJson(response.body['article']);
        return ApiResponse.success(article);
      } else {
        return ApiResponse.error(_getErrorMessage(response));
      }
    } catch (e) {
      return ApiResponse.error('Maqolani yuklashda xatolik: $e');
    }
  }

  // Progress tracking methods
  Future<ApiResponse<bool>> updateProgress(String themeId, bool completed) async {
    try {
      final body = {
        'theme_id': themeId,
        'completed': completed,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final response = await _httpClient.post('/progress', body);

      if (response.isOk) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(_getErrorMessage(response));
      }
    } catch (e) {
      return ApiResponse.error('Jarayonni saqlashda xatolik: $e');
    }
  }

  // Helper methods
  String _getErrorMessage(Response response) {
    if (response.statusCode == 401) {
      return 'Avtorizatsiya xatosi';
    } else if (response.statusCode == 403) {
      return 'Ruxsat yo\'q';
    } else if (response.statusCode == 404) {
      return 'Ma\'lumot topilmadi';
    } else if (response.statusCode == 500) {
      return 'Server xatosi';
    } else if (response.statusCode == null) {
      return 'Internet aloqasi yo\'q';
    } else {
      return 'Xatolik: ${response.statusCode}';
    }
  }

  // Network status check
  Future<bool> checkConnection() async {
    try {
      final response = await _httpClient.get('/health');
      return response.isOk;
    } catch (e) {
      return false;
    }
  }
}

// Generic API Response wrapper
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResponse.success(this.data)
      : error = null,
        isSuccess = true;

  ApiResponse.error(this.error)
      : data = null,
        isSuccess = false;

  bool get hasError => error != null;
  bool get hasData => data != null;
}
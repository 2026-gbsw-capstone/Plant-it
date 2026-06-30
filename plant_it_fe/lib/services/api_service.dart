import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:plant_it_fe/models/plant_ai_analysis_model.dart';
import 'package:plant_it_fe/models/plant_care_guide_model.dart';
import 'package:plant_it_fe/models/plant_diary_model.dart';
import 'package:plant_it_fe/models/plant_model.dart';
import 'package:plant_it_fe/models/user_model.dart';
import 'package:plant_it_fe/services/storage_service.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  static final String baseUrl =
      const String.fromEnvironment('API_BASE_URL', defaultValue: '').isNotEmpty
      ? const String.fromEnvironment('API_BASE_URL')
      : 'http://13.213.12.186/api/v1';

  final http.Client _client = http.Client();
  final StorageService _storage = StorageService.instance;

  Future<bool> hasSession() async {
    final token = await _storage.readAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> login({required String email, required String password}) async {
    final data = await _request<Map<String, dynamic>>(
      'POST',
      '/auth/login',
      body: {'email': email, 'password': password},
      auth: false,
    );
    await _storage.saveTokens(
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
    );
  }

  Future<void> googleLogin({required String idToken}) async {
    final data = await _request<Map<String, dynamic>>(
      'POST',
      '/auth/google',
      body: {'idToken': idToken},
      auth: false,
    );
    await _storage.saveTokens(
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
    );
  }

  Future<void> requestSignupEmailCode(String email) async {
    await _request<Map<String, dynamic>>(
      'POST',
      '/auth/signup/email/request',
      body: {'email': email},
      auth: false,
    );
  }

  Future<void> verifySignupEmailCode({
    required String email,
    required String code,
  }) async {
    await _request<void>(
      'POST',
      '/auth/signup/email/verify',
      body: {'email': email, 'code': code},
      auth: false,
    );
  }

  Future<void> signup({
    required String email,
    required String password,
    required String nickname,
  }) async {
    await _request<Map<String, dynamic>>(
      'POST',
      '/auth/signup',
      body: {'email': email, 'password': password, 'nickname': nickname},
      auth: false,
    );
    await login(email: email, password: password);
  }

  Future<String?> requestPasswordReset(String email) async {
    final data = await _request<Map<String, dynamic>>(
      'POST',
      '/auth/password/reset/request',
      body: {'email': email},
      auth: false,
    );
    return data['devCode'] as String?;
  }

  Future<String> verifyPasswordResetCode({
    required String email,
    required String code,
  }) async {
    final data = await _request<Map<String, dynamic>>(
      'POST',
      '/auth/password/reset/verify',
      body: {'email': email, 'code': code},
      auth: false,
    );
    return data['resetToken'] as String? ?? '';
  }

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    await _request<Map<String, dynamic>>(
      'POST',
      '/auth/password/reset/confirm',
      body: {'resetToken': resetToken, 'newPassword': newPassword},
      auth: false,
    );
  }

  Future<void> logout() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _request<void>(
        'POST',
        '/auth/logout',
        body: {'refreshToken': refreshToken},
      );
    }
    await _storage.clearTokens();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _request<void>(
      'PATCH',
      '/users/me/password',
      body: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }

  Future<List<Map<String, dynamic>>> getNotificationHistories() async {
    final data = await _request<List?>('GET', '/notifications/histories');
    return (data ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getNotificationSettings() async {
    final data = await _request<List?>('GET', '/notifications/settings');
    return (data ?? []).cast<Map<String, dynamic>>();
  }

  Future<void> updateNotificationSetting({
    required int plantId,
    bool? wateringEnabled,
    bool? fertilizerEnabled,
    bool? growthRecordEnabled,
    String? notificationTime,
  }) async {
    await _request<void>(
      'PATCH',
      '/notifications/settings',
      body: {
        'plantId': plantId,
        if (wateringEnabled != null) 'wateringEnabled': wateringEnabled,
        if (fertilizerEnabled != null) 'fertilizerEnabled': fertilizerEnabled,
        if (growthRecordEnabled != null) 'growthRecordEnabled': growthRecordEnabled,
        if (notificationTime != null) 'notificationTime': notificationTime,
      },
    );
  }

  Future<void> deleteAccount(String password) async {
    await _request<void>(
      'DELETE',
      '/users/me',
      body: {'password': password},
    );
    await _storage.clearTokens();
  }

  Future<void> resetData(String password) async {
    await _request<void>(
      'DELETE',
      '/users/me/data',
      body: {'password': password},
    );
  }

  Future<void> registerPushToken(String pushToken) async {
    await _request<void>(
      'POST',
      '/notifications/token',
      body: {'pushToken': pushToken},
    );
  }

  Future<String> uploadImageFile({
    required String filePath,
    required String type,
  }) async {
    final uri = Uri.parse('$baseUrl/uploads/images');
    final request = http.MultipartRequest('POST', uri)..fields['type'] = type;

    final token = await _storage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
        contentType: _imageContentType(filePath),
      ),
    );

    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    final decoded = _decodeResponse(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        decoded['message'] as String? ??
            _defaultErrorMessage(response.statusCode),
      );
    }
    if (decoded.containsKey('success') && decoded['success'] != true) {
      throw ApiException(decoded['message'] as String? ?? '업로드에 실패했습니다.');
    }

    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      final imageUrl = data['imageUrl'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty) return imageUrl;
    }
    throw ApiException('업로드 URL을 확인하지 못했습니다.');
  }

  Future<UserModel> getMe() async {
    final data = await _request<Map<String, dynamic>>('GET', '/users/me');
    return UserModel.fromJson(data);
  }

  Future<UserModel> updateMe({String? nickname, String? profileImageUrl}) async {
    final data = await _request<Map<String, dynamic>>(
      'PATCH',
      '/users/me',
      body: {
        'nickname': _emptyToNull(nickname),
        'profileImageUrl': profileImageUrl,
      },
    );
    return UserModel.fromJson(data);
  }

  Future<List<PlantModel>> getPlants({String? keyword}) async {
    final query = keyword == null || keyword.trim().isEmpty
        ? ''
        : '?keyword=${Uri.encodeQueryComponent(keyword.trim())}';
    final data = await _request<List<dynamic>>('GET', '/plants$query');
    return data
        .whereType<Map<String, dynamic>>()
        .map(PlantModel.fromJson)
        .toList();
  }

  Future<PlantModel> getPlant(int plantId) async {
    final data = await _request<Map<String, dynamic>>(
      'GET',
      '/plants/$plantId',
    );
    return PlantModel.fromJson(data);
  }

  Future<int> createPlant({
    required String name,
    String? speciesName,
    String? plantImageUrl,
    int? wateringCycleDays,
    int? fertilizerCycleDays,
    String? memo,
  }) async {
    final data = await _request<Map<String, dynamic>>(
      'POST',
      '/plants',
      body: {
        'name': name,
        'speciesName': _emptyToNull(speciesName),
        'plantImageUrl': _emptyToNull(plantImageUrl),
        'wateringCycleDays': wateringCycleDays,
        'fertilizerCycleDays': fertilizerCycleDays,
        'memo': _emptyToNull(memo),
      },
    );
    return (data['plantId'] as num?)?.toInt() ?? 0;
  }

  Future<PlantModel> updatePlant(
    int plantId, {
    String? name,
    String? speciesName,
    String? plantImageUrl,
    int? wateringCycleDays,
    int? fertilizerCycleDays,
    String? memo,
  }) async {
    final data = await _request<Map<String, dynamic>>(
      'PATCH',
      '/plants/$plantId',
      body: {
        'name': _emptyToNull(name),
        'speciesName': _emptyToNull(speciesName),
        'plantImageUrl': _emptyToNull(plantImageUrl),
        'wateringCycleDays': wateringCycleDays,
        'fertilizerCycleDays': fertilizerCycleDays,
        'memo': _emptyToNull(memo),
      },
    );
    return PlantModel.fromJson(data);
  }

  Future<void> deletePlant(int plantId) async {
    await _request<void>('DELETE', '/plants/$plantId');
  }

  Future<void> waterPlant(int plantId, {DateTime? wateredAt}) async {
    await _request<void>(
      'POST',
      '/plants/$plantId/water',
      body: {'wateredAt': (wateredAt ?? DateTime.now()).toIso8601String()},
    );
  }

  Future<void> fertilizePlant(int plantId, {DateTime? fertilizedAt}) async {
    await _request<void>(
      'POST',
      '/plants/$plantId/fertilizer',
      body: {
        'fertilizedAt': (fertilizedAt ?? DateTime.now()).toIso8601String(),
      },
    );
  }

  Future<List<PlantDiaryModel>> getDiaries(int plantId) async {
    final data = await _request<List<dynamic>>(
      'GET',
      '/plants/$plantId/diaries',
    );
    return data
        .whereType<Map<String, dynamic>>()
        .map(PlantDiaryModel.fromJson)
        .toList();
  }

  Future<int> createDiary(
    int plantId, {
    String? imageUrl,
    String? note,
    DateTime? recordedAt,
    bool analyzeHealth = false,
    String diaryType = 'GROWTH',
  }) async {
    final data = await _request<Map<String, dynamic>>(
      'POST',
      '/plants/$plantId/diaries',
      body: {
        'imageUrl': _emptyToNull(imageUrl),
        'note': _emptyToNull(note),
        'recordedAt': (recordedAt ?? DateTime.now()).toIso8601String(),
        'analyzeHealth': analyzeHealth,
        'diaryType': diaryType,
      },
    );
    return (data['diaryId'] as num?)?.toInt() ?? 0;
  }

  Future<List<PlantCareGuideModel>> getGuides({String? keyword}) async {
    final query = keyword == null || keyword.trim().isEmpty
        ? ''
        : '?keyword=${Uri.encodeQueryComponent(keyword.trim())}';
    final data = await _request<List<dynamic>>('GET', '/guide/plants$query');
    return data
        .whereType<Map<String, dynamic>>()
        .map(PlantCareGuideModel.fromJson)
        .toList();
  }

  Future<PlantCareGuideModel> getGuide(int guideId) async {
    final data = await _request<Map<String, dynamic>>(
      'GET',
      '/guide/plants/$guideId',
    );
    return PlantCareGuideModel.fromJson(data);
  }

  Future<IdentifyPlantResponseModel> identifyPlant({
    required String imageUrl,
  }) async {
    final data = await _request<Map<String, dynamic>>(
      'POST',
      '/ai/plants/identify',
      body: {'imageUrl': imageUrl},
    );
    return IdentifyPlantResponseModel.fromJson(data);
  }

  Future<ChatResponseModel> chat({
    required int plantId,
    required String question,
    String? imageUrl,
  }) async {
    final data = await _request<Map<String, dynamic>>(
      'POST',
      '/ai/chat',
      body: {
        'plantId': plantId,
        'question': question,
        'imageUrl': _emptyToNull(imageUrl),
      },
    );
    return ChatResponseModel.fromJson(data);
  }

  Future<HealthCheckResponseModel> healthCheck({
    required int plantId,
    required String imageUrl,
  }) async {
    final data = await _request<Map<String, dynamic>>(
      'POST',
      '/ai/plants/health-check',
      body: {'plantId': plantId, 'imageUrl': imageUrl},
    );
    return HealthCheckResponseModel.fromJson(data);
  }

  Future<T> _request<T>(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final token = await _storage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final encodedBody = body == null ? null : jsonEncode(_withoutNulls(body));
    final response = switch (method) {
      'GET' => await _client.get(uri, headers: headers),
      'POST' => await _client.post(uri, headers: headers, body: encodedBody),
      'PATCH' => await _client.patch(uri, headers: headers, body: encodedBody),
      'DELETE' => await _client.delete(
        uri,
        headers: headers,
        body: encodedBody,
      ),
      _ => throw ApiException('지원하지 않는 HTTP 메서드입니다.'),
    };

    final decoded = _decodeResponse(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        decoded['message'] as String? ??
            _defaultErrorMessage(response.statusCode),
      );
    }
    if (decoded.containsKey('success') && decoded['success'] != true) {
      throw ApiException(decoded['message'] as String? ?? '요청에 실패했습니다.');
    }
    final data = decoded.containsKey('data') ? decoded['data'] : decoded;
    if (data == null || T == Null || T.toString() == 'void') return null as T;
    return data as T;
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    final body = utf8.decode(response.bodyBytes).trim();
    if (body.isEmpty) return <String, dynamic>{};

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        rethrow;
      }
    }

    return <String, dynamic>{
      'message': _defaultErrorMessage(response.statusCode),
    };
  }

  static String _defaultErrorMessage(int statusCode) {
    if (statusCode == 502) {
      return '서버 연결이 불안정합니다. 잠시 후 다시 시도해주세요.';
    }
    if (statusCode >= 500) {
      return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    }
    return '요청에 실패했습니다.';
  }

  static Map<String, dynamic> _withoutNulls(Map<String, dynamic> value) {
    return Map.fromEntries(value.entries.where((entry) => entry.value != null));
  }

  static String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static MediaType _imageContentType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return switch (extension) {
      'png' => MediaType('image', 'png'),
      'webp' => MediaType('image', 'webp'),
      'heic' => MediaType('image', 'heic'),
      'heif' => MediaType('image', 'heif'),
      _ => MediaType('image', 'jpeg'),
    };
  }
}

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

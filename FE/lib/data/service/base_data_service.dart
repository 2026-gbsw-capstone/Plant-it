import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../etc/etc.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String? code;

  const ApiException({
    required this.statusCode,
    required this.message,
    this.code,
  });

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message, code: $code)';
  }
}

class BaseDataService {
  BaseDataService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri buildUri(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    final uri = etc.backendUrl.resolve(normalizedPath);

    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }

    return uri.replace(
      queryParameters: queryParameters.map(
        (key, value) => MapEntry(key, value?.toString()),
      )..removeWhere((key, value) => value == null || value.isEmpty),
    );
  }

  Future<dynamic> getData(
    String path, {
    String? accessToken,
    Map<String, dynamic>? queryParameters,
  }) {
    return _send(
      method: 'GET',
      path: path,
      accessToken: accessToken,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> postData(
    String path, {
    String? accessToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) {
    return _send(
      method: 'POST',
      path: path,
      accessToken: accessToken,
      body: body,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> patchData(
    String path, {
    String? accessToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) {
    return _send(
      method: 'PATCH',
      path: path,
      accessToken: accessToken,
      body: body,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> deleteData(
    String path, {
    String? accessToken,
    Map<String, dynamic>? queryParameters,
  }) {
    return _send(
      method: 'DELETE',
      path: path,
      accessToken: accessToken,
      queryParameters: queryParameters,
    );
  }

  Future<T> getObject<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    String? accessToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    final data = await getData(
      path,
      accessToken: accessToken,
      queryParameters: queryParameters,
    );
    return fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<List<T>> getList<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    String? accessToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    final data = await getData(
      path,
      accessToken: accessToken,
      queryParameters: queryParameters,
    );
    return _decodeList(data, fromJson);
  }

  Future<T> postObject<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    String? accessToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final data = await postData(
      path,
      accessToken: accessToken,
      body: body,
      queryParameters: queryParameters,
    );
    return fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<List<T>> _decodeList<T>(
    dynamic data,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    if (data is! List) {
      return const [];
    }

    return data
        .map((item) => fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<dynamic> _send({
    required String method,
    required String path,
    String? accessToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = buildUri(path, queryParameters: queryParameters);
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
    };

    late final http.Response response;

    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
      case 'POST':
        response = await _client.post(
          uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
      case 'PATCH':
        response = await _client.patch(
          uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
      case 'DELETE':
        response = await _client.delete(uri, headers: headers);
      default:
        throw UnsupportedError('Unsupported method: $method');
    }

    return _extractData(response);
  }

  dynamic _extractData(http.Response response) {
    final hasBody = response.body.trim().isNotEmpty;
    final decoded = hasBody ? jsonDecode(response.body) : <String, dynamic>{};

    if (decoded is! Map<String, dynamic>) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      }
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Unexpected response format.',
      );
    }

    final success = decoded['success'];
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        success == false) {
      throw ApiException(
        statusCode: response.statusCode,
        message: decoded['message']?.toString() ?? 'Request failed.',
        code: decoded['code']?.toString(),
      );
    }

    return decoded['data'];
  }
}

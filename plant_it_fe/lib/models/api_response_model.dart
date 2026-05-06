class ApiResponse<T> {
  final bool success;
  final String message;
  final String? code;
  final T? data;

  const ApiResponse({
    required this.success,
    required this.message,
    this.code,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? parseData,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      code: json['code'] as String?,
      data: parseData == null ? null : parseData(json['data']),
    );
  }

  Map<String, dynamic> toJson(Object? Function(T data)? encodeData) {
    return {
      'success': success,
      'message': message,
      if (code != null) 'code': code,
      if (data != null)
        'data': encodeData == null ? data : encodeData(data as T),
    };
  }
}

T? readJsonValue<T>(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (json.containsKey(key) && json[key] != null) {
      return json[key] as T;
    }
  }
  return null;
}

int? readInt(Map<String, dynamic> json, List<String> keys) {
  final value = readJsonValue<dynamic>(json, keys);
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.parse(value.toString());
}

String? readString(Map<String, dynamic> json, List<String> keys) {
  final value = readJsonValue<dynamic>(json, keys);
  return value?.toString();
}

bool? readBool(Map<String, dynamic> json, List<String> keys) {
  final value = readJsonValue<dynamic>(json, keys);
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  return value.toString().toLowerCase() == 'true';
}

DateTime? readDateTime(Map<String, dynamic> json, List<String> keys) {
  final value = readString(json, keys);
  if (value == null || value.isEmpty) {
    return null;
  }
  return DateTime.parse(value);
}

String? writeDateTime(DateTime? value) => value?.toIso8601String();

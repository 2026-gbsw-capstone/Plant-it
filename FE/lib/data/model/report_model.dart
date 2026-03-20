import 'model_utils.dart';

enum ReportTargetType { post, comment }

extension ReportTargetTypeJson on ReportTargetType {
  static ReportTargetType fromJson(String value) {
    switch (value) {
      case 'POST':
        return ReportTargetType.post;
      case 'COMMENT':
        return ReportTargetType.comment;
      default:
        throw ArgumentError('Unknown targetType: $value');
    }
  }

  String toJson() {
    switch (this) {
      case ReportTargetType.post:
        return 'POST';
      case ReportTargetType.comment:
        return 'COMMENT';
    }
  }
}

class ReportModel {
  final int id;
  final int reporterUserId;
  final ReportTargetType targetType;
  final int targetId;
  final String reason;
  final DateTime createdAt;

  const ReportModel({
    required this.id,
    required this.reporterUserId,
    required this.targetType,
    required this.targetId,
    required this.reason,
    required this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: readInt(json, ['id'])!,
      reporterUserId: readInt(
        json,
        ['reporter_user_id', 'reporterUserId'],
      )!,
      targetType: ReportTargetTypeJson.fromJson(
        readString(json, ['target_type', 'targetType'])!,
      ),
      targetId: readInt(json, ['target_id', 'targetId'])!,
      reason: readString(json, ['reason'])!,
      createdAt: readDateTime(json, ['created_at', 'createdAt'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporter_user_id': reporterUserId,
      'target_type': targetType.toJson(),
      'target_id': targetId,
      'reason': reason,
      'created_at': writeDateTime(createdAt),
    };
  }
}

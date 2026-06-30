import 'dart:ffi';

/// 법적 문서를 구성하는 데이터 모델.
class LegalDoc {
  const LegalDoc({
    required this.title,
    required this.effectiveDate,
    this.intro,
    required this.sections,
    this.closing,
  });

  /// 문서 제목 (예: 서비스 이용약관)
  final String title;

  /// 시행일 (예: 2026년 6월 17일)
  final String effectiveDate;

  /// 본문 시작 전 안내 문단
  final String? intro;

  final List<LegalSection> sections;

  /// 문서 말미 부칙/안내
  final String? closing;
}

class LegalSection {
  const LegalSection({
    required this.heading,
    this.body,
    this.bullets,
    this.table,
  });

  /// 조/항 제목 (예: 제1조(목적))
  final String heading;

  /// 일반 본문 (여러 문단은 \n\n 으로 구분)
  final String? body;

  /// 글머리 목록
  final List<String>? bullets;

  /// 표 — 첫 번째 행을 헤더로 사용
  final List<List<String>>? table;
}

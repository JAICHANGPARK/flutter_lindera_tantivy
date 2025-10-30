import 'dart:convert';

/// 문서 데이터 모델 클래스
class DocumentData {
  final String title;
  final String body;
  final Map<String, dynamic> metadata;

  DocumentData({
    required this.title,
    required this.body,
    required this.metadata,
  });

  /// JSON에서 DocumentData 객체 생성
  factory DocumentData.fromJson(Map<String, dynamic> json) {
    return DocumentData(
      title: json['title'] as String,
      body: json['body'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
    );
  }

  /// DocumentData를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'metadata': metadata,
    };
  }

  /// metadata를 JSON 문자열로 변환
  String get metadataJsonString => jsonEncode(metadata);

  @override
  String toString() {
    return 'DocumentData(title: $title, body: ${body.substring(0, body.length > 30 ? 30 : body.length)}..., metadata: $metadata)';
  }
}


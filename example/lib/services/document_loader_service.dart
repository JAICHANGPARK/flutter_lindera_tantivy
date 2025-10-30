import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/document_data.dart';
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

/// 문서 로더 서비스 클래스
class DocumentLoaderService {
  /// JSON 파일에서 문서 데이터를 로드합니다
  static Future<List<DocumentData>> loadDocumentsFromJson(String assetPath) async {
    try {
      // assets 폴더에서 JSON 파일 읽기
      final String jsonString = await rootBundle.loadString(assetPath);

      // JSON 파싱
      final List<dynamic> jsonList = jsonDecode(jsonString);

      // DocumentData 객체 리스트로 변환
      final List<DocumentData> documents = jsonList
          .map((json) => DocumentData.fromJson(json as Map<String, dynamic>))
          .toList();

      return documents;
    } catch (e) {
      throw Exception('JSON 파일 로드 중 오류 발생: $e');
    }
  }

  /// DocumentData 리스트를 Tantivy 인덱스에 추가합니다
  static Future<String> addDocumentsToIndex(List<DocumentData> documents) async {
    try {
      // DocumentData를 DocumentInput으로 변환
      final List<DocumentInput> documentInputs = documents
          .map((doc) => DocumentInput(
                id: '', // 빈 문자열이면 UUID 자동 생성
                title: doc.title,
                body: doc.body,
                metadata: doc.metadataJsonString,
              ))
          .toList();

      // Rust 함수 호출하여 문서 추가
      final result = await addDocuments(documents: documentInputs);
      return result;
    } catch (e) {
      throw Exception('문서 추가 중 오류 발생: $e');
    }
  }

  /// JSON 파일을 읽고 바로 인덱스에 추가합니다
  static Future<String> loadAndAddDocuments(String assetPath) async {
    final documents = await loadDocumentsFromJson(assetPath);
    final result = await addDocumentsToIndex(documents);
    return result;
  }

  /// 샘플 문서를 로드합니다 (기본값: assets/sample_documents.json)
  static Future<String> loadSampleDocuments() async {
    return await loadAndAddDocuments('assets/sample_documents.json');
  }
}


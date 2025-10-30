import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult result;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SearchResultCard({
    super.key,
    required this.result,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // metadata JSON 파싱
    Map<String, dynamic> metadata = {};
    try {
      metadata = json.decode(result.metadata);
    } catch (e) {
      debugPrint('Metadata 파싱 오류: $e');
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 순위와 점수
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '⭐ ${result.score.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 본문 내용
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                result.body.length > 150
                    ? '${result.body.substring(0, 150)}...'
                    : result.body,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Metadata 섹션
            if (metadata.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Metadata',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _buildMetadataChips(context, metadata),
              ),
            ],

            const SizedBox(height: 12),

            // 하단 액션 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ID 표시 (축약)
                Expanded(
                  child: Text(
                    'ID: ${result.id.length > 20 ? "${result.id.substring(0, 20)}..." : result.id}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
                // 액션 버튼
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('수정', style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('삭제', style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Metadata를 Chip 위젯으로 변환하는 헬퍼 함수
  List<Widget> _buildMetadataChips(
    BuildContext context,
    Map<String, dynamic> metadata,
  ) {
    final chips = <Widget>[];
    final colorScheme = Theme.of(context).colorScheme;

    metadata.forEach((key, value) {
      // 값의 타입에 따라 다르게 표시
      String displayValue;
      Color chipColor;
      IconData? icon;

      if (value is List) {
        // 배열의 각 요소를 문자열로 변환하고 null 제거
        final stringList = value
            .where((item) => item != null)
            .map((item) => item.toString())
            .toList();

        if (stringList.isEmpty) {
          return; // 빈 배열은 표시하지 않음
        }

        displayValue = '$key: ${stringList.join(", ")}';
        chipColor = colorScheme.secondaryContainer;
        icon = Icons.list;
      } else if (value is num) {
        displayValue = '$key: $value';
        chipColor = colorScheme.tertiaryContainer;
        icon = Icons.numbers;
      } else if (value is bool) {
        displayValue = '$key: $value';
        chipColor = colorScheme.primaryContainer;
        icon = Icons.check_circle_outline;
      } else if (value == null) {
        return; // null 값은 표시하지 않음
      } else {
        displayValue = '$key: $value';
        chipColor = colorScheme.surfaceContainerHighest;

        // 특정 키에 대한 아이콘 설정
        if (key == 'author') {
          icon = Icons.person;
          chipColor = colorScheme.tertiaryContainer;
        } else if (key == 'createdAt' || key == 'lastModified') {
          icon = Icons.calendar_today;
          chipColor = colorScheme.primaryContainer;
        } else if (key == 'rating') {
          icon = Icons.star;
          chipColor = colorScheme.tertiaryContainer;
        } else if (key == 'views' || key == 'likes' || key == 'visitors') {
          icon = Icons.visibility;
          chipColor = colorScheme.secondaryContainer;
        } else if (key == 'category') {
          icon = Icons.category;
          chipColor = colorScheme.primaryContainer;
        } else if (key == 'language') {
          icon = Icons.language;
          chipColor = colorScheme.secondaryContainer;
        } else if (key == 'tags') {
          icon = Icons.label;
          chipColor = colorScheme.secondaryContainer;
        }
      }

      chips.add(
        Chip(
          avatar: icon != null
              ? Icon(
                  icon,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.7),
                )
              : null,
          label: Text(
            displayValue,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: chipColor,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    });

    return chips;
  }
}

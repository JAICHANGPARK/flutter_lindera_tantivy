import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// 선택된 사전 타입을 관리하는 Provider
final dictionaryTypeProvider = StateProvider<DictionaryType>(
  (ref) => DictionaryType.korean,
);

class DictionarySelector extends ConsumerWidget {
  const DictionarySelector({super.key});

  String _getDictionaryLabel(DictionaryType type) {
    switch (type) {
      case DictionaryType.korean:
        return '한국어 (ko-dic)';
      case DictionaryType.japaneseIpadic:
        return '日本語 (IPADIC)';
      // case DictionaryType.japaneseIpadicNeologd:
      //   return '日本語 (IPADIC NEologd)';
      case DictionaryType.japaneseUnidic:
        return '日本語 (UniDic)';
      case DictionaryType.chinese:
        return '中文 (CC-CEDICT)';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDictionary = ref.watch(dictionaryTypeProvider);

    return PopupMenuButton<DictionaryType>(
      icon: const Icon(Icons.book),
      tooltip: 'Select Dictionary',
      onSelected: (DictionaryType type) {
        ref.read(dictionaryTypeProvider.notifier).state = type;
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: DictionaryType.korean,
          child: Row(
            children: [
              if (selectedDictionary == DictionaryType.korean)
                const Icon(Icons.check, size: 16)
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text(_getDictionaryLabel(DictionaryType.korean)),
            ],
          ),
        ),
        PopupMenuItem(
          value: DictionaryType.japaneseIpadic,
          child: Row(
            children: [
              if (selectedDictionary == DictionaryType.japaneseIpadic)
                const Icon(Icons.check, size: 16)
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text(_getDictionaryLabel(DictionaryType.japaneseIpadic)),
            ],
          ),
        ),
        PopupMenuItem(
          value: DictionaryType.japaneseUnidic,
          child: Row(
            children: [
              if (selectedDictionary == DictionaryType.japaneseUnidic)
                const Icon(Icons.check, size: 16)
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text(_getDictionaryLabel(DictionaryType.japaneseUnidic)),
            ],
          ),
        ),
        PopupMenuItem(
          value: DictionaryType.chinese,
          child: Row(
            children: [
              if (selectedDictionary == DictionaryType.chinese)
                const Icon(Icons.check, size: 16)
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text(_getDictionaryLabel(DictionaryType.chinese)),
            ],
          ),
        ),
      ],
    );
  }
}

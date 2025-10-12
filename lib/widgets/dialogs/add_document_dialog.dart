import 'package:flutter/material.dart';
import 'package:tantivy_flutter_app/l10n/app_localizations.dart';
import 'package:tantivy_flutter_app/src/rust/api/search.dart';

class AddDocumentDialog extends StatefulWidget {
  final VoidCallback onDocumentAdded;

  const AddDocumentDialog({
    super.key,
    required this.onDocumentAdded,
  });

  @override
  State<AddDocumentDialog> createState() => _AddDocumentDialogState();
}

class _AddDocumentDialogState extends State<AddDocumentDialog> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final metadataController = TextEditingController(text: '{}');

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    metadataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.addDocument),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.autoGenerateUuid,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: l10n.title,
                hintText: l10n.enterTitle,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(
                labelText: l10n.content,
                hintText: l10n.enterContent,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: metadataController,
              decoration: InputDecoration(
                labelText: l10n.metadataJson,
                hintText: '{"country": "한국", "city": "서울"}',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () async {
            if (titleController.text.trim().isEmpty ||
                bodyController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.titleAndContentRequired)),
              );
              return;
            }

            try {
              final result = addDocument(
                title: titleController.text.trim(),
                body: bodyController.text.trim(),
                metadataJson: metadataController.text.trim(),
              );

              if (mounted) {
                Navigator.pop(context);
                widget.onDocumentAdded();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.addFailed(e.toString()))),
                );
              }
            }
          },
          child: Text(l10n.add),
        ),
      ],
    );
  }
}

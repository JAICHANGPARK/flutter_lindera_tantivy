import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 웹 플랫폼에서는 Rust FFI를 지원하지 않음
  if (!kIsWeb) {
    await RustLib.init();
  }

  runApp(const ProviderScope(child: MyApp()));
}

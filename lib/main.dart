import 'dart:async';

import 'package:flutter/material.dart';

import 'core/services/audio_service.dart';
import 'core/theme/app_theme.dart';
import 'name_entry_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'وُجِدَ أَمِينًا',
      theme: AppTheme.dark,
      home: const NameEntryPage(),
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!AudioService.instance.userActivated) {
              unawaited(AudioService.instance.initializeFromUserAction());
            }
          },
          child: child,
        );
      },
    );
  }
}

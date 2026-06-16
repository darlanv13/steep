import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'layout/main_layout.dart';

void main() {
  runApp(const SgsvApp());
}

class SgsvApp extends StatelessWidget {
  const SgsvApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGSV Mineração - VPS Vale',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainLayout(),
    );
  }
}

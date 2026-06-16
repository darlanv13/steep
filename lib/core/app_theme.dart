import 'package:flutter/material.dart';

class AppTheme {
  // Cores Base VPS Vale
  static const Color verdeVale = Color(0xFF007A53);
  static const Color verdeEscuro = Color(0xFF005C3E);
  static const Color amareloVale = Color(0xFFF4A900);

  // Cores de Superfície e Fundo
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardColor = Colors.white;
  static const Color textoPrincipal = Color(0xFF2C3E50);
  static const Color textoSecundario = Color(0xFF7F8C8D);

  // Status Colors (Criticidade)
  static const Color alertaCritico = Color(0xFFE74C3C);
  static const Color sucesso = Color(0xFF27AE60);

  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      primaryColor: verdeVale,
      fontFamily: 'FontAwesome', // Garanta que a fonte está no pubspec.yaml
      appBarTheme: const AppBarTheme(
        backgroundColor: verdeVale,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: verdeVale,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

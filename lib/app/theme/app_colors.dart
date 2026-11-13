import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // اللون الجديد مستوحى من خطوط الخريطة
  static const Color accent = Color(0xFFAED581); 
  static const Color accentMuted = Color(0xFF4A4A38);
  static const Color error = Color(0xFFCF6679);
  
  static const Color kgrey = Colors.grey;
  static const Color kWhite = Colors.white;
  static const Color kBlack = Colors.black;

  // ─── ألوان قديمة تم إعادتها لتجنب كسر الشاشات الأخرى ───────────────────────
  static const Color kGreyCard = Color(0xFF1E1E1E);
  static const Color kBorderColor = Color(0xFF2A2A2A);
  static const Color kTabGreyColor = Color.fromARGB(255, 108, 106, 105);
  static const Color kPureBlack = Colors.black;
  static Color kLightGrey = Color.fromARGB(15, 66, 66, 66);
  static Color kBlackTranslucent = Color.fromARGB(196, 0, 0, 0);
  static Color kPrimaryGrey = Color.fromARGB(255, 232, 232, 232);
  static Color kOrange = Colors.orange;
  
  static const Color background = Color(0xFF1A1A18);
  static const Color surface = Color(0xFF242420);
  static const Color surfaceVariant = Color(0xFF2E2E2A);
  
  static const Color noteCard = Color(0xFFE8ECC8);
  static const Color textPrimary = Color(0xFFF0F0EC);
  static const Color textSecondary = Color(0xFFAAADA0);
  static const Color textMuted = Color(0xFF666860);
  static const Color textOnLight = Color(0xFF1A1A18);
  static const Color success = Color(0xFF81C784);
  static const Color warning = Color(0xFFFFB74D);
}
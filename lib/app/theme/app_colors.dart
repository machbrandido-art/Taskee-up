import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // الألوان الأساسية الجديدة المستوحاة من الخريطة
  static const Color accent = Color(0xFFAED581); // الأخضر النعناعي
  static const Color accentMuted = Color(0xFF4A4A38); // أعدنا هذا السطر لحل المشكلة
  static const Color error = Color(0xFFCF6679);
  
  // ألوان مساعدة
  static const Color kWhite = Colors.white;
  static const Color kBlack = Colors.black;
  static const Color kgrey = Colors.grey;
}
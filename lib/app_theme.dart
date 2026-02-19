import 'package:flutter/material.dart';

class AppTheme {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF3BD1A1),
      Color(0xFF8BF7AB),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
class AppColors {
  static const Color primary = Color(0xFF3BD1A1); // première couleur du gradient
  static const Color primaryLight = Color(0xFF8BF7AB);

  static const Color white = Colors.white;
  static const Color text = Color(0xFF1E1E1E);

  static const Color greenLight = Color(0xFFE6F9F1);
  static const Color greenDark = Color(0xFF1E8E6A);

  static const Color yellowLight = Color(0xFFFFF8E1);
  static const Color yellow = Color(0xFFF9A825);

  static const Color redLight = Color(0xFFFFEBEE);
  static const Color red = Color(0xFFD32F2F);
}

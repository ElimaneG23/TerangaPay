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
  // Gradient principal
  static const Color primary = Color(0xFF3BD1A1);
  static const Color primaryLight = Color(0xFF8BF7AB);

  // Couleurs de base
  static const Color white = Colors.white;
  static const Color text = Color(0xFF1E1E1E);       // Texte principal
  static const Color sub = Color(0xFF7A7A7A);        // Texte secondaire / hint
  static const Color bg = Color(0xFFF5F5F5);         // Fond des cases vides
  static const Color border = Color(0xFFE0E0E0);     // Bordures des cases

  // Couleurs vertes
  static const Color green = Color(0xFF3BD1A1);      // Vert principal
  static const Color greenLight = Color(0xFFE6F9F1); // Vert clair / cases remplies
  static const Color greenDark = Color(0xFF1E8E6A);  // Vert foncé si besoin

  // Couleurs jaunes
  static const Color yellowLight = Color(0xFFFFF8E1);
  static const Color yellow = Color(0xFFF9A825);

  // Couleurs rouges
  static const Color redLight = Color(0xFFFFEBEE);
  static const Color red = Color(0xFFD32F2F);
}

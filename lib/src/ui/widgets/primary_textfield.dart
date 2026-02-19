import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class PrimaryTextField extends StatelessWidget {
  final String hint;
  final String? label;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? suffix;
  final LinearGradient? gradient; // <- gradient
  final void Function(String)? onChanged; // <- callback ajouté

  const PrimaryTextField({
    super.key,
    required this.hint,
    this.label,
    this.obscure = false,
    this.keyboardType,
    this.controller,
    this.suffix,
    this.gradient,
    this.onChanged, // <- assigné ici
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
        ],

        // Gradient autour du champ
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: gradient,
          ),
          child: Container(
            margin: const EdgeInsets.all(1.5), // simulate border
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.text,
              ),
              onChanged: onChanged, // <-- ici
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: AppColors.text.withOpacity(0.5),
                ),
                suffixIcon: suffix,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

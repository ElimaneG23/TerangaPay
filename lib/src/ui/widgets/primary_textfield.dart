import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class PrimaryTextField extends StatelessWidget {
  final String hint;
  final String? label;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? suffix;

  const PrimaryTextField({
    super.key,
    required this.hint,
    this.label,
    this.obscure = false,
    this.keyboardType,
    this.controller,
    this.suffix,
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

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary, // première couleur du gradient
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.text,
            ),
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
      ],
    );
  }
}



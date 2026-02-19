import 'package:flutter/material.dart';
import '../../../app_theme.dart';


class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text(
            "Continuer",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

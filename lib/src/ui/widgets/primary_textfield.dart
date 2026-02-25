import 'package:flutter/material.dart';
import '../../../app_theme.dart';



class PrimaryTextField extends StatefulWidget {
  final String hint;
  final String? label;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? suffix;
  final LinearGradient? gradient;
  final void Function(String)? onChanged;
  final String? Function(String? value)? validator;

  const PrimaryTextField({
    super.key,
    required this.hint,
    this.label,
    this.obscure = false,
    this.keyboardType,
    this.controller,
    this.suffix,
    this.gradient,
    this.onChanged,
    this.validator,
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  String? _errorText;

  void _handleChanged(String value) {
    if (_errorText != null) {
      setState(() => _errorText = widget.validator?.call(value));
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
        ],

        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: hasError
                ? const LinearGradient(
                    colors: [Color(0xFFE74C3C), Color(0xFFFF6B6B)],
                  )
                : widget.gradient,
          ),
          child: Container(
            margin: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(              // ← TextFormField (pas TextField)
              controller: widget.controller,
              obscureText: widget.obscure,
              keyboardType: widget.keyboardType,
              style: const TextStyle(fontSize: 14, color: AppColors.text),
              onChanged: _handleChanged,
              validator: (value) {
                final error = widget.validator?.call(value);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _errorText = error);
                });
                return error;
              },
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: AppColors.text.withOpacity(0.45),
                  fontSize: 13,
                ),
                suffixIcon: widget.suffix,
                errorStyle: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFE74C3C),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border:             InputBorder.none,
                errorBorder:        InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                enabledBorder:      InputBorder.none,
                focusedBorder:      InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
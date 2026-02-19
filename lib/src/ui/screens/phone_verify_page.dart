import 'package:flutter/material.dart';
import 'package:terangapay/src/ui/widgets/primary_button.dart';
import '../../../app_theme.dart';
import '../../utiles/myAssets/image_assets.dart';
import '../widgets/primary_textfield.dart';
import 'otp_page.dart';

class PhoneVerifyPage extends StatefulWidget {
  const PhoneVerifyPage({super.key});

  @override
  State<PhoneVerifyPage> createState() => _PhoneVerifyPageState();
}

class _PhoneVerifyPageState extends State<PhoneVerifyPage> {
  String _phone = '';
  final _controller = TextEditingController();

  // Formatte le numéro: XX XXX XX XX
  String get _formattedPhone {
    if (_phone.isEmpty) return '';
    final digits = _phone.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5 || i == 7) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  void initState() {
    super.initState();
    _controller.text = _formattedPhone;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String val) {
    // Garde uniquement les chiffres
    final digits = val.replaceAll(RegExp(r'[^0-9]'), '');
    setState(() {
      _phone = digits;
      _controller.value = TextEditingValue(
        text: _formattedPhone,
        selection: TextSelection.collapsed(offset: _formattedPhone.length),
      );
    });
  }

  void _goToOtp() {
    if (_phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez entrer un numéro valide'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OtpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(ImagesAssets.terangaPay),
              const SizedBox(height: 28),
              const Text(
                'Entrez votre numéro\nde téléphone',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),

              // Champ numéro de téléphone
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.greenLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Text('🇸🇳', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 4),
                        Text(
                          '+221',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryTextField(
                      controller: _controller,
                      hint: 'XX XXX XX XX',
                      keyboardType: TextInputType.phone, // Clavier numérique
                      gradient: AppTheme.primaryGradient,
                      onChanged: _onChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              PrimaryButton(
                label: 'Suivant',
                onTap: _goToOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

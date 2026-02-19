import 'package:flutter/material.dart';
import 'package:terangapay/src/ui/widgets/primary_button.dart';
import '../../../app_theme.dart';
import '../../utiles/myAssets/image_assets.dart';
import 'login_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _onChanged(String val, int index) {
    if (val.isNotEmpty && val.length > 1) {
      // garder seulement le premier caractère
      _controllers[index].text = val[0];
    }
    if (val.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus(); // passer à la case suivante
    }
    if (val.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus(); // revenir en arrière si backspace
    }
    setState(() {}); // pour mettre à jour le design si besoin
  }

  void _confirm() {
    if (_otpCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez entrer le code à 4 chiffres'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
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
                'Entrez le code envoyé',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Un code a été envoyé à votre numéro de téléphone',
                style: TextStyle(fontSize: 13, color: AppColors.sub, height: 1.5),
              ),
              const SizedBox(height: 28),

              // OTP cases
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  return Container(
                    width: 56,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.green,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: _controllers[i].text.isEmpty
                            ? AppColors.bg
                            : AppColors.greenLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _controllers[i].text.isEmpty
                                ? AppColors.border
                                : AppColors.green,
                            width: _controllers[i].text.isEmpty ? 1 : 1.5,
                          ),
                        ),
                      ),
                      onChanged: (val) => _onChanged(val, i),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              PrimaryButton(
                label: 'Confirmer',
                onTap: _confirm,
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Renvoyer le code',
                    style: TextStyle(
                        color: AppColors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

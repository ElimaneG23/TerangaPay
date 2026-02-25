import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:terangapay/src/ui/widgets/primary_button.dart';
import '../../../app_theme.dart';
import '../../utiles/myAssets/image_assets.dart';
// ✅ Import direct vers Dashboard avec les données utilisateur
import 'dashbord_page.dart' show DashboardPage, User;

class OtpPage extends StatefulWidget {
  // ✅ Données reçues de PhoneVerifyPage → RegisterPage
  final String nom;
  final String prenom;
  final String email;
  final String telephone;

  const OtpPage({
    super.key,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _resendSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _startResendTimer() async {
    for (int i = 60; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _resendSeconds = i;
        _canResend = i == 0;
      });
    }
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _onChanged(String val, int index) {
    // Gestion du collage
    if (val.length > 1) {
      final digits = val.replaceAll(RegExp(r'[^0-9]'), '');
      for (int i = 0; i < 4 && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      _focusNodes[3].requestFocus();
      setState(() {});
      return;
    }
    if (val.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (val.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _confirm() {
    if (_otpCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez entrer le code à 4 chiffres'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // ✅ Navigation vers Dashboard avec les vraies données utilisateur
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardPage(
          currentUser: User(
            prenom:    widget.prenom,
            nom:       widget.nom,
            telephone: widget.telephone,
            solde:     0, // TODO: récupérer depuis l'API
          ),
        ),
      ),
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
              // ✅ Affiche le numéro réel
              Text(
                'Un code a été envoyé au +221 ${widget.telephone}',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.sub, height: 1.5),
              ),
              const SizedBox(height: 36),

              // ── Cases OTP ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final isFilled = _controllers[i].text.isNotEmpty;
                  return Container(
                    width: 60, height: 64,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: isFilled ? AppTheme.primaryGradient : null,
                      border: isFilled
                          ? null
                          : Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Container(
                      margin: isFilled ? const EdgeInsets.all(1.5) : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: isFilled ? AppColors.greenLight : AppColors.bg,
                        borderRadius: BorderRadius.circular(isFilled ? 12 : 14),
                      ),
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: isFilled ? AppColors.greenDark : AppColors.text,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border:             InputBorder.none,
                          enabledBorder:      InputBorder.none,
                          focusedBorder:      InputBorder.none,
                        ),
                        onChanged: (val) => _onChanged(val, i),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              PrimaryButton(label: 'Confirmer', onTap: _confirm),

              const SizedBox(height: 16),

              Center(
                child: _canResend
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _canResend = false;
                            _resendSeconds = 60;
                          });
                          _startResendTimer();
                        },
                        child: ShaderMask(
                          shaderCallback: (b) =>
                              AppTheme.primaryGradient.createShader(b),
                          child: const Text(
                            'Renvoyer le code',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        'Renvoyer dans $_resendSeconds s',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.sub),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
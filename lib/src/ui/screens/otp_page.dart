import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:terangapay/models/user_model.dart';
import 'package:terangapay/src/ui/widgets/primary_button.dart';
import '../../../app_theme.dart';
import '../../utiles/myAssets/image_assets.dart';
import 'dashbord_page.dart';

class OtpPage extends StatefulWidget {
  final String nom;
  final String prenom;
  final String? email;
  final String telephone;

  const OtpPage({
    super.key,
    required this.nom,
    required this.prenom,
    this.email,
    required this.telephone,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _resendSeconds = 60;
  bool _canResend = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    _animController.dispose();
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
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Veuillez entrer le code à 4 chiffres'),
            ],
          ),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    final user = UserModel(
      id: 0,
      prenom: widget.prenom,
      nom: widget.nom,
      email: widget.email ?? '',
      telephone: widget.telephone,
      pin: '',
      solde: 0.0,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => DashboardPage(currentUser: user)),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Progression visuelle : nb chiffres remplis / 4
    final filledCount =
        _controllers.where((c) => c.text.isNotEmpty).length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // ── Blobs décoratifs ──
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Header : back + logo ──
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: AppColors.text,
                                size: 16,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              ImagesAssets.terangaPay,
                              height: 28,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // ── Icône illustrative ──
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.greenLight,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          color: AppColors.primary,
                          size: 26,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Titre ──
                      const Text(
                        'Entrez le code\nde vérification',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                          height: 1.3,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.sub,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(text: 'Code envoyé au '),
                            TextSpan(
                              text: '+221 ${widget.telephone}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Carte OTP ──
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Cases OTP
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (i) {
                                final isFilled =
                                    _controllers[i].text.isNotEmpty;
                                final isFocused =
                                    _focusNodes[i].hasFocus;
                                return AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 200),
                                  width: 62,
                                  height: 68,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 6),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(16),
                                    color: isFilled
                                        ? AppColors.greenLight
                                        : AppColors.bg,
                                    border: Border.all(
                                      color: isFilled
                                          ? AppColors.primary
                                          : isFocused
                                          ? AppColors.primary
                                          .withOpacity(0.5)
                                          : AppColors.border,
                                      width: isFilled || isFocused
                                          ? 2
                                          : 1.5,
                                    ),
                                    boxShadow: isFilled
                                        ? [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withOpacity(0.15),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                        : [],
                                  ),
                                  child: TextField(
                                    controller: _controllers[i],
                                    focusNode: _focusNodes[i],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: isFilled
                                          ? AppColors.greenDark
                                          : AppColors.text,
                                    ),
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (val) =>
                                        _onChanged(val, i),
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 20),

                            // Barre de progression
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: filledCount / 4,
                                backgroundColor: AppColors.border,
                                valueColor:
                                AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                                minHeight: 3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$filledCount / 4 chiffres',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.sub.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      PrimaryButton(label: 'Confirmer', onTap: _confirm),

                      const SizedBox(height: 20),

                      // ── Renvoyer le code ──
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.greenLight,
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: ShaderMask(
                              shaderCallback: (b) =>
                                  AppTheme.primaryGradient
                                      .createShader(b),
                              child: const Text(
                                'Renvoyer le code',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: AppColors.sub.withOpacity(0.6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Renvoyer dans $_resendSeconds s',
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                AppColors.sub.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
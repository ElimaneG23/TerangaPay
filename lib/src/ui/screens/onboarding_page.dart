import 'package:flutter/material.dart';
import 'package:terangapay/src/ui/screens/login_page.dart';
import 'package:terangapay/src/ui/widgets/primary_button.dart';
import '../../../app_theme.dart';
import 'package:terangapay/src/utiles/myAssets/image_assets.dart';

import 'register_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _ctrl = PageController();
  int _current = 0;

  late AnimationController _textAnimController;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  final List<_SlideData> _slides = [
    _SlideData(
      asset: ImagesAssets.phone,
      title: 'Envoyer de l\'argent en\nquelques secondes',
      subtitle: 'Envoyer de l\'argent instantanément\npartout au Sénégal',
      isLast: false,
      bgColor: AppColors.greenLight,
      accentColor:  AppColors.primary,
    ),
    _SlideData(
      asset: ImagesAssets.security,
      title: 'Sécurité garantie',
      subtitle: 'Vos transactions sont protégées\npar un code PIN sécurisé',
      isLast: false,
      bgColor: AppColors.greenLight,
      accentColor:  AppColors.green,
    ),
    _SlideData(
      asset: ImagesAssets.trust,
      title: 'L\'hospitalité au service\nde votre argent',
      subtitle:
      'Une solution simple, rapide et sécurisée\npour gérer vos finances au quotidien',
      isLast: true,
      bgColor: AppColors.greenLight,
      accentColor: AppColors.primaryLight,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _textAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _textFade =
        CurvedAnimation(parent: _textAnimController, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _textAnimController, curve: Curves.easeOut));
    _textAnimController.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _textAnimController.dispose();
    super.dispose();
  }

  void _next() {
    if (_current < _slides.length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_current];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // ── Fond animé coloré ──
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: slide.bgColor.withOpacity(0.5),
            ),
          ),

          // ── Blob décoratif haut-droite ──
          Positioned(
            top: -80,
            right: -80,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: slide.accentColor.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: slide.accentColor.withOpacity(0.07),
              ),
            ),
          ),
          // ── Blob bas-gauche ──
          Positioned(
            bottom: 180,
            left: -50,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: slide.accentColor.withOpacity(0.06),
              ),
            ),
          ),

          // ── PageView ──
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) {
              setState(() => _current = i);
              _textAnimController.reset();
              _textAnimController.forward();
            },
            itemCount: _slides.length,
            itemBuilder: (_, i) => _SlidePage(
              data: _slides[i],
              textFade: _textFade,
              textSlide: _textSlide,
            ),
          ),

          // ── Bouton Skip ──
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 20, 0),
                child: AnimatedOpacity(
                  opacity: _current < _slides.length - 1 ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: _skip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Passer',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.sub,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Contrôles bas ──
          Positioned(
            bottom: 0,
            left: 24,
            right: 24,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      final isActive = _current == i;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: isActive
                              ? AppTheme.primaryGradient
                              : null,
                          color: isActive ? null : Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  // Bouton principal
                  PrimaryButton(
                    label: _slides[_current].isLast ? 'Commencer' : 'Suivant',
                    onTap: _next,
                  ),

                  const SizedBox(height: 14),

                  // Lien connexion (dernière slide)
                  AnimatedOpacity(
                    opacity: _current == _slides.length - 1 ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: _skip,
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          'J\'ai déjà un compte',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Slide Page ─────────────────────────────────────────────────────────────────
class _SlidePage extends StatelessWidget {
  final _SlideData data;
  final Animation<double> textFade;
  final Animation<Offset> textSlide;

  const _SlidePage({
    required this.data,
    required this.textFade,
    required this.textSlide,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ── Illustration ──
            Expanded(
              flex: 5,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Cercle de fond grand
                    Container(
                      width: size.width * 0.65,
                      height: size.width * 0.65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data.accentColor.withOpacity(0.12),
                      ),
                    ),
                    // Cercle de fond moyen
                    Container(
                      width: size.width * 0.48,
                      height: size.width * 0.48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data.accentColor.withOpacity(0.10),
                      ),
                    ),
                    // Image
                    Image.asset(
                      data.asset,
                      width: size.width * 0.52,
                      height: size.width * 0.52,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),

            // ── Texte animé ──
            Expanded(
              flex: 3,
              child: FadeTransition(
                opacity: textFade,
                child: SlideTransition(
                  position: textSlide,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                          height: 1.35,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        data.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.sub,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Espace pour les contrôles
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

// ── Modèle Slide ───────────────────────────────────────────────────────────────
class _SlideData {
  final String asset;
  final String title;
  final String subtitle;
  final bool isLast;
  final Color bgColor;
  final Color accentColor;

  const _SlideData({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.isLast,
    required this.bgColor,
    required this.accentColor,
  });
}
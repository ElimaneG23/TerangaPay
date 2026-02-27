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

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _ctrl = PageController();
  int _current = 0;

  final List<_SlideData> _slides = [
    _SlideData(
      asset: ImagesAssets.phone, // <- ton asset
      title: 'Envoyer de l\'argent en\nquelques secondes',
      subtitle: 'Envoyer de l\'argent instantanément partout au Sénégal',
      isLast: false,
    ),
    _SlideData(
      asset: ImagesAssets.security,
      title: 'Sécurité garantie',
      subtitle: 'Vos transactions sont protégées\npar un code PIN sécurisé',
      isLast: false,
    ),
    _SlideData(
      asset: ImagesAssets.trust,
      title: 'L\'hospitalité au service\nde votre argent',
      subtitle:
      'Une solution simple, rapide et sécurisée\npour gérer vos finances au quotidien',
      isLast: true,
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _slides.length,
            itemBuilder: (_, i) => _SlidePage(data: _slides[i]),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 24,
            right: 24,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dots indicateurs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      final isActive = _current == i;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: isActive ? AppTheme.primaryGradient : null,
                          color: isActive ? null : Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  // Bouton primaire
                  PrimaryButton(
                    label: _slides[_current].isLast ? 'Commencer' : 'Suivant',
                    onTap: _next,
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

// Widget pour chaque slide
class _SlidePage extends StatelessWidget {
  final _SlideData data;
  const _SlidePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Logo
            // const TerangaPayLogo(),

            const SizedBox(height: 60),

            // Cercle principal avec gradient
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent.shade100, // couleur du grand cercle
              ),
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      data.asset!, // ton chemin d'icône depuis IconAssets
                      width: 500,
                      height: 500,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),

            Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 100),

            Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modèle de slide avec uniquement Image.asset
class _SlideData {
  final String asset; // chemin de l'image
  final String title;
  final String subtitle;
  final bool isLast;

  const _SlideData({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.isLast,
  });
}



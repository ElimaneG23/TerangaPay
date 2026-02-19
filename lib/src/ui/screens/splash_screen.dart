import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import 'package:terangapay/src/utiles/myAssets/image_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/onboarding_page');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Stack(
        children: [

          /// 🔹 Lignes décoratives en haut
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: Image.asset(
          //     ImagesAssets.topLines, // 👉 crée une image svg/png lignes
          //     fit: BoxFit.cover,
          //   ),
          // ),

          /// 🔹 Lignes décoratives en bas
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Image.asset(
          //     ImagesAssets.bottomLines,
          //     fit: BoxFit.cover,
          //   ),
          // ),

          /// 🔥 Logo + Texte centré
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// Logo
                Image.asset(
                  ImagesAssets.logo,
                  height: 80,
                ),

                const SizedBox(height: 20),

                /// Texte avec gradient
                ShaderMask(
                  shaderCallback: (bounds) {
                    return AppTheme.primaryGradient
                        .createShader(bounds);
                  },
                  child: const Text(
                    "TerangaPay",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

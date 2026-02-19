import 'dart:async';
import 'package:flutter/material.dart';
import 'package:terangapay/src/utiles/myAssets/image_assets.dart';
import 'package:terangapay/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Redirection vers onboarding après 3 secondes
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond avec gradient

          // 🔥 Logo + texte centré
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset(ImagesAssets.logo, height: 90),

                const SizedBox(height: 20),

                // TerangaPay avec couleur du primaryGradient
                ShaderMask(
                  shaderCallback: (bounds) {
                    return primaryGradient.createShader(bounds);
                  },
                  child: const Text(
                    "TerangaPay",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // nécessaire pour ShaderMask
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

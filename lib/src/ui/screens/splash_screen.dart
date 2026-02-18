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
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: primaryGradient,
        ),
        child: Center(
          child: Image.asset(ImagesAssets.logo, width: 150, height: 150),
        ),
      ),
    );
  }
}

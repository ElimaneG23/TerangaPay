import 'package:flutter/material.dart';
import 'package:terangapay/src/ui/routes/route_path.dart';
import 'package:terangapay/src/ui/screens/onboarding_page.dart';

import '../screens/splash_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    case splash:
    return MaterialPageRoute(builder: (_) => const SplashScreen());
    case onboarding:
    return MaterialPageRoute(builder: (_) => const OnboardingPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
import 'package:flutter/material.dart';
import 'package:terangapay/src/ui/routes/route_path.dart';
import 'package:terangapay/src/ui/screens/login_page.dart';
import 'package:terangapay/src/ui/screens/onboarding_page.dart';
import 'package:terangapay/src/ui/screens/otp_page.dart';
import 'package:terangapay/src/ui/screens/phone_verify_page.dart';
import 'package:terangapay/src/ui/screens/register_page.dart';

import '../screens/splash_screen.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    case splash:
    return MaterialPageRoute(builder: (_) => const SplashScreen());
    case onboarding:
    return MaterialPageRoute(builder: (_) => const OnboardingPage());
    case registerPage:
    return MaterialPageRoute(builder: (_) => const RegisterPage());
      case phoneVerifyPage:
        return MaterialPageRoute(builder: (_) => const PhoneVerifyPage(nom: '', prenom: '', email: '', ));
      case otp:
        return MaterialPageRoute(builder: (_) => const OtpPage(nom: '', prenom: '', email: '', telephone: ''));
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
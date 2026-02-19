import 'package:flutter/material.dart';
import 'package:terangapay/src/ui/widgets/primary_button.dart';
import 'package:terangapay/src/utiles/myAssets/image_assets.dart';
import '../../../app_theme.dart';
import '../widgets/primary_textfield.dart';
import 'phone_verify_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nom     = TextEditingController();
  final _prenom  = TextEditingController();
  final _email   = TextEditingController();
  final _pin     = TextEditingController();
  final _pinConf = TextEditingController();

  // Méthode de validation
  bool _validateInputs() {
    // Vérifier que tous les champs sont remplis
    if (_nom.text.isEmpty ||
        _prenom.text.isEmpty ||
        _email.text.isEmpty ||
        _pin.text.isEmpty ||
        _pinConf.text.isEmpty) {
      _showSnackBar('Veuillez remplir tous les champs');
      return false;
    }

    // Vérifier que l'email contient au moins un "@"
    if (!_email.text.contains('@')) {
      _showSnackBar('Veuillez entrer un email valide');
      return false;
    }

    // Vérifier que le PIN contient uniquement des chiffres
    if (!RegExp(r'^[0-9]+$').hasMatch(_pin.text)) {
      _showSnackBar('Le code PIN doit contenir uniquement des chiffres');
      return false;
    }

    // Vérifier que la confirmation PIN est identique et uniquement des chiffres
    if (!RegExp(r'^[0-9]+$').hasMatch(_pinConf.text)) {
      _showSnackBar('La confirmation du PIN doit contenir uniquement des chiffres');
      return false;
    }

    if (_pin.text != _pinConf.text) {
      _showSnackBar('Les codes PIN ne correspondent pas');
      return false;
    }

    return true; // tout est valide
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Image.asset(ImagesAssets.terangaPay),
              const SizedBox(height: 15),
              const Text(
                'Créer votre compte',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 24),

              // Nom
              PrimaryTextField(
                label: 'Nom',
                hint: 'Entrez le nom',
                controller: _nom,
                gradient: AppTheme.primaryGradient,
              ),
              const SizedBox(height: 16),

              // Prénom
              PrimaryTextField(
                label: 'Prénom',
                hint: 'Entrez le prénom',
                controller: _prenom,
                gradient: AppTheme.primaryGradient,
              ),
              const SizedBox(height: 16),

              // Email
              PrimaryTextField(
                label: 'E-mail',
                hint: 'Entrez l\'email',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                gradient: AppTheme.primaryGradient,
              ),
              const SizedBox(height: 16),

              // Code PIN
              PrimaryTextField(
                label: 'Code PIN',
                hint: 'Entrez le code PIN',
                controller: _pin,
                obscure: true,
                keyboardType: TextInputType.number,
                gradient: AppTheme.primaryGradient,
              ),
              const SizedBox(height: 16),

              // Confirmer PIN
              PrimaryTextField(
                label: 'Confirmer le code PIN',
                hint: 'Confirmez le code PIN',
                controller: _pinConf,
                obscure: true,
                keyboardType: TextInputType.number,
                gradient: AppTheme.primaryGradient,
              ),
              const SizedBox(height: 32),

              // Bouton Suivant
              PrimaryButton(
                label: 'Suivant',
                onTap: () {
                  if (_validateInputs()) {
                    // Si tout est correct, passer à la page suivante
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PhoneVerifyPage()),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

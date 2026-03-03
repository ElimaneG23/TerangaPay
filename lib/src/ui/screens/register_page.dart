import 'package:flutter/material.dart';
import 'package:terangapay/src/ui/widgets/form_validators.dart';
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
  // ✅ ÉTAPE 1 — Déclarer la clé
  final _formKey = GlobalKey<FormState>();

  final _nom     = TextEditingController();
  final _prenom  = TextEditingController();
  final _email   = TextEditingController();
  final _pin     = TextEditingController();
  final _pinConf = TextEditingController();

  @override
  void dispose() {
    _nom.dispose();
    _prenom.dispose();
    _email.dispose();
    _pin.dispose();
    _pinConf.dispose();
    super.dispose();
  }

  void _submit() {
    // ✅ ÉTAPE 3 — Déclenche tous les validators d'un coup
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return; // les erreurs s'affichent sous chaque champ

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhoneVerifyPage(
          nom:    _nom.text.trim(),
          prenom: _prenom.text.trim(),
          email:  _email.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        // ✅ ÉTAPE 2 — Envelopper avec Form + clé
        child: Form(
          key: _formKey,
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

                PrimaryTextField(
                  label: 'Nom',
                  hint: 'Entrez le nom',
                  keyboardType: TextInputType.name,
                  validator: FormValidators.validateNom,
                  controller: _nom,
                  gradient: AppTheme.primaryGradient,
                ),
                const SizedBox(height: 16),

                PrimaryTextField(
                  label: 'Prénom',
                  hint: 'Entrez le prénom',
                  keyboardType: TextInputType.name,
                  validator: FormValidators.validatePrenom,
                  controller: _prenom,
                  gradient: AppTheme.primaryGradient,
                ),
                const SizedBox(height: 16),

                PrimaryTextField(
                  label: 'E-mail',
                  hint: "Entrez l'email",
                  validator: FormValidators.validateEmail,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  gradient: AppTheme.primaryGradient,
                ),
                const SizedBox(height: 16),

                PrimaryTextField(
                  label: 'Code PIN',
                  hint: 'Entrez le code PIN',
                  validator: (value) => FormValidators.validatePin(value, _pin.text),
                  controller: _pin,
                  obscure: true,
                  keyboardType: TextInputType.number,
                  gradient: AppTheme.primaryGradient,
                ),
                const SizedBox(height: 16),

                PrimaryTextField(
                  label: 'Confirmer le code PIN',
                  hint: 'Confirmez le code PIN',
                  validator: (value) =>
                      FormValidators.validateConfirmPassword(value, _pin.text),
                  controller: _pinConf,
                  obscure: true,
                  keyboardType: TextInputType.number,
                  gradient: AppTheme.primaryGradient,
                ),
                const SizedBox(height: 32),

                PrimaryButton(
                  label: 'Suivant',
                  onTap: _submit, // ✅ appelle _submit — plus de logique inline
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
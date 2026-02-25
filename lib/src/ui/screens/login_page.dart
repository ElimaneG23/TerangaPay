import 'package:flutter/material.dart';
import 'package:terangapay/src/utiles/form_validators.dart';
import '../../../app_theme.dart';
import '../../utiles/myAssets/image_assets.dart';
import '../widgets/primary_button.dart';
import '../widgets/primary_textfield.dart';
// ✅ Import avec 'show' pour éviter le conflit AppColors
import 'dashbord_page.dart' show DashboardPage, User;
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ✅ Clé du formulaire
  final _formKey = GlobalKey<FormState>();

  final _phone  = TextEditingController();
  final _pin    = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _phone.dispose();
    _pin.dispose();
    super.dispose();
  }

  void _login() {
    // ✅ Déclenche tous les validators
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    // ✅ Utilisateur construit depuis les champs réels de connexion
    // Le prénom et le solde viendront de votre API plus tard
    final user = User(
      prenom:    'Utilisateur',       // TODO: récupérer depuis l'API
      nom:       '',
      telephone: _phone.text.trim(),
      solde:     0,                   // TODO: récupérer depuis l'API
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => DashboardPage(currentUser: user)),
      (_) => false,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        // ✅ Couleur directe — pas besoin de AppColors ici
        backgroundColor: const Color(0xFFE74C3C),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        // ✅ Form avec clé
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(child: Image.asset(ImagesAssets.terangaPay)),
                const SizedBox(height: 36),

                const Text(
                  'CONNEXION',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 28),

                // ✅ Seulement téléphone + PIN pour se connecter
                PrimaryTextField(
                  label: 'Numéro de téléphone',
                  hint: 'Entrez votre numéro',
                  validator: FormValidators.validateTelephone,
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  gradient: AppTheme.primaryGradient,
                ),
                const SizedBox(height: 16),

                // Code PIN
                PrimaryTextField(
                  label: 'Code PIN',
                  hint: 'Entrez votre code PIN',
                  // ✅ validatePin prend 1 seul argument
                 // ❌ Erreur – signature incompatible

                // ✅ Correction – lambda explicite
                  validator: (value) => FormValidators.validatePin(value, _pin.text),
                  controller: _pin,
                  obscure: _obscure,
                  keyboardType: TextInputType.number,
                  gradient: AppTheme.primaryGradient,
                  suffix: GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.sub,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                PrimaryButton(
                  label: 'Se Connecter',
                  onTap: _login,
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Pas encore de compte ? ',
                        style: TextStyle(fontSize: 13, color: AppColors.sub)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      ),
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Social icons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialBtn(icon: Icons.g_mobiledata_rounded),
                    SizedBox(width: 16),
                    _SocialBtn(icon: Icons.facebook_rounded),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  const _SocialBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.sub, size: 24),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:terangapay/models/user_model.dart';
import '../../../app_theme.dart';
import '../../utiles/myAssets/image_assets.dart';
import '../widgets/primary_button.dart';
import '../widgets/primary_textfield.dart';
import 'dashbord_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phone = TextEditingController();
  final _pin = TextEditingController();
  bool _obscure = true;

  /// Charger les utilisateurs depuis le JSON
  Future<List<UserModel>> _loadUsers() async {
    final String response =
    await rootBundle.loadString('assets/data/users.json');

    final List<dynamic> data = json.decode(response);

    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  /// Fonction login
  void _login() async {
    if (_phone.text.isEmpty) {
      _showSnackBar('Veuillez entrer votre numéro de téléphone');
      return;
    }

    if (_pin.text.isEmpty) {
      _showSnackBar('Veuillez entrer votre code PIN');
      return;
    }

    final users = await _loadUsers();

    try {
      final user = users.firstWhere(
            (u) =>
        u.telephone == _phone.text.trim() &&
            u.pin == _pin.text.trim(),
      );


    } catch (e) {
      _showSnackBar("Numéro ou PIN incorrect");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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

              /// Logo
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

              /// Téléphone
              PrimaryTextField(
                label: 'Numéro de téléphone',
                hint: 'Entrez votre numéro',
                controller: _phone,
                keyboardType: TextInputType.phone,
                gradient: AppTheme.primaryGradient,
              ),

              const SizedBox(height: 16),

              /// PIN
              PrimaryTextField(
                label: 'Code PIN',
                hint: 'Entrez votre code PIN',
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

              /// Bouton connexion
              PrimaryButton(
                label: 'Se Connecter',
                onTap: _login,
              ),

              const SizedBox(height: 24),

              /// Lien inscription
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pas encore de compte ? ',
                    style:
                    TextStyle(fontSize: 13, color: AppColors.sub),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterPage()),
                    ),
                    child: const Text(
                      'S\'inscrire',
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

              /// Social Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _SocialBtn(icon: Icons.g_mobiledata_rounded),
                  SizedBox(width: 16),
                  _SocialBtn(icon: Icons.facebook_rounded),
                ],
              ),
            ],
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
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: AppColors.sub,
        size: 24,
      ),
    );
  }
}

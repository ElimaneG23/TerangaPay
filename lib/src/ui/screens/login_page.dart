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

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _phone = TextEditingController();
  final _pin = TextEditingController();
  bool _obscure = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _phone.dispose();
    _pin.dispose();
    _animController.dispose();
    super.dispose();
  }

  /// Charger les utilisateurs depuis le JSON
  Future<List<UserModel>> _loadUsers() async {
    final String response =
    await rootBundle.loadString('assets/data/users.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  /// Fonction login
  void _login() async {
    if (_phone.text.trim().isEmpty) {
      _showSnackBar('Veuillez entrer votre numéro de téléphone');
      return;
    }
    if (_pin.text.trim().isEmpty) {
      _showSnackBar('Veuillez entrer votre code PIN');
      return;
    }

    final users = await _loadUsers();

    try {
      final user = users.firstWhere(
            (u) =>
        u.telephone.trim() == _phone.text.trim() &&
            u.pin?.trim() == _pin.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(currentUser: user),
        ),
      );
    } catch (e) {
      _showSnackBar("Numéro ou PIN incorrect");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // ── Blob décoratif haut ──
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.06),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      /// ── Logo centré ──
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            ImagesAssets.terangaPay,
                            height: 48,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// ── Titre ──
                      const Text(
                        'Bon retour 👋',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Connectez-vous pour accéder à votre compte',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.sub,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      /// ── Carte formulaire ──
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Téléphone
                            _FieldLabel(label: 'Numéro de téléphone'),
                            const SizedBox(height: 8),
                            PrimaryTextField(
                              label: '',
                              hint: '+221 XX XXX XX XX',
                              controller: _phone,
                              keyboardType: TextInputType.phone,
                              gradient: AppTheme.primaryGradient,
                            ),

                            const SizedBox(height: 20),

                            /// PIN
                            _FieldLabel(label: 'Code PIN'),
                            const SizedBox(height: 8),
                            PrimaryTextField(
                              label: '',
                              hint: '••••••',
                              controller: _pin,
                              obscure: _obscure,
                              keyboardType: TextInputType.number,
                              gradient: AppTheme.primaryGradient,
                              suffix: GestureDetector(
                                onTap: () =>
                                    setState(() => _obscure = !_obscure),
                                child: Icon(
                                  _obscure
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color:  AppColors.sub,
                                  size: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Code PIN oublié ?',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// ── Bouton connexion ──
                      PrimaryButton(
                        label: 'Se Connecter',
                        onTap: _login,
                      ),

                      const SizedBox(height: 28),

                      /// ── Divider ──
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  height: 1,
                                  color: AppColors.border)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'ou',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.sub,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  height: 1,
                                  color: AppColors.border)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// ── Lien inscription ──
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Pas encore de compte ? ',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.sub,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterPage()),
                              ),
                              child: const Text(
                                "S'inscrire",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── Field Label ───────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
        letterSpacing: 0.2,
      ),
    );
  }
}
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

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nom     = TextEditingController();
  final _prenom  = TextEditingController();
  final _email   = TextEditingController();
  final _pin     = TextEditingController();
  final _pinConf = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _nom.dispose();
    _prenom.dispose();
    _email.dispose();
    _pin.dispose();
    _pinConf.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

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
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // ── Blob décoratif haut-droite ──
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
            top: 50,
            right: 30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Header : back + logo ──
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: AppColors.text,
                                  size: 16,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                ImagesAssets.terangaPay,
                                height: 28,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // ── Titre ──
                        const Text(
                          'Créer un compte',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Remplissez les informations ci-dessous',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.sub,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Carte formulaire : infos personnelles ──
                        _FormCard(
                          title: 'Informations personnelles',
                          icon: Icons.person_rounded,
                          children: [
                            _FieldLabel(label: 'Nom'),
                            const SizedBox(height: 8),
                            PrimaryTextField(
                              label: '',
                              hint: 'Entrez votre nom',
                              keyboardType: TextInputType.name,
                              validator: FormValidators.validateNom,
                              controller: _nom,
                              gradient: AppTheme.primaryGradient,
                            ),
                            const SizedBox(height: 16),
                            _FieldLabel(label: 'Prénom'),
                            const SizedBox(height: 8),
                            PrimaryTextField(
                              label: '',
                              hint: 'Entrez votre prénom',
                              keyboardType: TextInputType.name,
                              validator: FormValidators.validatePrenom,
                              controller: _prenom,
                              gradient: AppTheme.primaryGradient,
                            ),
                            const SizedBox(height: 16),
                            _FieldLabel(label: 'E-mail'),
                            const SizedBox(height: 8),
                            PrimaryTextField(
                              label: '',
                              hint: "Entrez votre email",
                              validator: FormValidators.validateEmail,
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              gradient: AppTheme.primaryGradient,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ── Carte formulaire : sécurité ──
                        _FormCard(
                          title: 'Sécurité',
                          icon: Icons.lock_rounded,
                          children: [
                            _FieldLabel(label: 'Code PIN'),
                            const SizedBox(height: 8),
                            PrimaryTextField(
                              label: '',
                              hint: '••••••',
                              validator: (value) =>
                                  FormValidators.validatePin(value, _pin.text),
                              controller: _pin,
                              obscure: true,
                              keyboardType: TextInputType.number,
                              gradient: AppTheme.primaryGradient,
                            ),
                            const SizedBox(height: 16),
                            _FieldLabel(label: 'Confirmer le code PIN'),
                            const SizedBox(height: 8),
                            PrimaryTextField(
                              label: '',
                              hint: '••••••',
                              validator: (value) =>
                                  FormValidators.validateConfirmPassword(
                                      value, _pin.text),
                              controller: _pinConf,
                              obscure: true,
                              keyboardType: TextInputType.number,
                              gradient: AppTheme.primaryGradient,
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // ── Bouton Suivant ──
                        PrimaryButton(
                          label: 'Suivant',
                          onTap: _submit,
                        ),

                        const SizedBox(height: 20),

                        // ── Lien connexion ──
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Déjà un compte ? ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.sub,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  'Se connecter',
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

                        const SizedBox(height: 24),
                      ],
                    ),
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

// ── Form Card ─────────────────────────────────────────────────────────────────
class _FormCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _FormCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de la carte
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

// ── Field Label ───────────────────────────────────────────────────────────────
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
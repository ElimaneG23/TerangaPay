import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:terangapay/models/user_model.dart';
import 'package:terangapay/src/ui/screens/history_page.dart'
    show Transaction, TransactionType, sampleTransactions, formatAmount;
import '../../../app_theme.dart';

class TransfertPage extends StatefulWidget {
  final UserModel currentUser;
  final VoidCallback? onTransactionUpdate;

  const TransfertPage({
    super.key,
    required this.currentUser,
    this.onTransactionUpdate,
  });

  @override
  State<TransfertPage> createState() => _TransfertPageState();
}

class _TransfertPageState extends State<TransfertPage> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _selectedContact;
  late double _solde;

  final List<Map<String, String>> _recentContacts = [
    {'name': 'Abdoulaye B.', 'phone': '+221 77 123 45 67', 'initials': 'AB'},
    {'name': 'Fatou Diallo', 'phone': '+221 76 987 65 43', 'initials': 'FD'},
    {'name': 'Moussa Sy', 'phone': '+221 78 111 22 33', 'initials': 'MS'},
    {'name': 'Aïssatou N.', 'phone': '+221 70 444 55 66', 'initials': 'AN'},
  ];

  @override
  void initState() {
    super.initState();
    _solde = widget.currentUser.solde;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _selectContact(Map<String, String> contact) {
    setState(() {
      _selectedContact = contact['name'];
      _phoneController.text = contact['phone']!;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount =
        int.tryParse(_amountController.text.replaceAll(' ', '')) ?? 0;

    if (amount > _solde) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solde insuffisant'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (!mounted) return;

    setState(() {
      _solde -= amount;
      widget.currentUser.solde = _solde;
    });

    sampleTransactions.insert(
      0,
      Transaction(
        name: _selectedContact ?? _phoneController.text,
        reference: 'TERANGA-${DateTime.now().millisecondsSinceEpoch}',
        amount: amount,
        type: TransactionType.send,
        status: 'completed',
        date: DateTime.now(),
      ),
    );

    widget.onTransactionUpdate?.call();
    _showSuccessSheet(amount);
  }

  void _showSuccessSheet(int amount) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _SuccessSheet(
        name: _selectedContact ?? _phoneController.text,
        amount: amount,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            title: const Text(
              'Transfert',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solde actuel : ${formatAmount(_solde.toInt())} FCFA',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              const _SectionLabel('Contacts récents'),
              const SizedBox(height: 10),
              SizedBox(
                height: 88,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recentContacts.length,
                  itemBuilder: (_, i) {
                    final c = _recentContacts[i];
                    final selected = _selectedContact == c['name'];

                    return GestureDetector(
                      onTap: () => _selectContact(c),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: selected
                                    ? AppTheme.primaryGradient
                                    : null,
                                color: selected
                                    ? null
                                    : AppColors.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                c['initials']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              c['name']!.split(' ').first,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.text),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              const _SectionLabel('Numéro de téléphone'),
              const SizedBox(height: 8),
              _InputField(
                controller: _phoneController,
                hint: '+221 XX XXX XX XX',
                icon: Icons.phone_outlined,
                focusedColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
              const _SectionLabel('Montant (FCFA)'),
              const SizedBox(height: 8),
              _InputField(
                controller: _amountController,
                hint: '0',
                icon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                focusedColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: _isLoading ? null : _submit,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius:
                      BorderRadius.all(Radius.circular(14)),
                    ),
                    alignment: Alignment.center,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                        color: Colors.white)
                        : const Text(
                      'ENVOYER',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Color? focusedColor;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.focusedColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = focusedColor ?? AppColors.primary;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(color: AppColors.text),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.sub),
        prefixIcon: Icon(icon, color: primary),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}

class _SuccessSheet extends StatelessWidget {
  final String name;
  final int amount;
  final VoidCallback onClose;

  const _SuccessSheet({
    required this.name,
    required this.amount,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, color: primary, size: 38),
          ),
          const SizedBox(height: 16),
          const Text(
            'Transfert réussi !',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            '${formatAmount(amount)} envoyé à $name',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: const Text(
                'TERMINER',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:terangapay/src/ui/screens/history_page.dart'
    show AppColors, Transaction, TransactionType, sampleTransactions, formatAmount;

// ─────────────────────────────────────────
//  PAGE TRANSFERT
// ─────────────────────────────────────────
class TransfertPage extends StatefulWidget {
  const TransfertPage({super.key});

  @override
  State<TransfertPage> createState() => _TransfertPageState();
}

class _TransfertPageState extends State<TransfertPage> {
  final _phoneController  = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController   = TextEditingController();
  final _formKey          = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _selectedContact;

  final List<Map<String, String>> _recentContacts = [
    {'name': 'Abdoulaye B.', 'phone': '+221 77 123 45 67', 'initials': 'AB'},
    {'name': 'Fatou Diallo',  'phone': '+221 76 987 65 43', 'initials': 'FD'},
    {'name': 'Moussa Sy',     'phone': '+221 78 111 22 33', 'initials': 'MS'},
    {'name': 'Aïssatou N.',   'phone': '+221 70 444 55 66', 'initials': 'AN'},
  ];

  @override
  void initState() {
    super.initState();
    // ✅ Mise à jour du récapitulatif en temps réel
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectContact(Map<String, String> contact) {
    setState(() {
      _selectedContact = contact['name'];
      _phoneController.text = contact['phone']!;
    });
  }

  // ✅ Montant parsé proprement
  int get _parsedAmount =>
      int.tryParse(_amountController.text.replaceAll(' ', '')) ?? 0;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (!mounted) return;

    sampleTransactions.insert(
      0,
      Transaction(
        name: _selectedContact ?? _phoneController.text,
        reference: 'TERANGA-${DateTime.now().millisecondsSinceEpoch}',
        amount: _parsedAmount,
        type: TransactionType.send,
        status: 'completed',
        date: DateTime.now(),
      ),
    );

    _showSuccessSheet(_parsedAmount);
  }

  void _showSuccessSheet(int amount) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _SuccessSheet(
        name: _selectedContact ?? _phoneController.text,
        amount: amount,
        onClose: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasAmount = _parsedAmount > 0;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: BackButton(color: AppColors.text),
        ),
        title: const Text(
          'Transfert',
          style: TextStyle(
              color: AppColors.greenDark,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Contacts récents ──
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
                              width: 52, height: 52,
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.green
                                    : AppColors.greenLight,
                                shape: BoxShape.circle,
                                border: selected
                                    ? Border.all(
                                        color: AppColors.greenDark, width: 2)
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                c['initials']!,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.greenDark,
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
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Numéro destinataire ──
              const _SectionLabel('Numéro de téléphone'),
              const SizedBox(height: 8),
              _InputField(
                controller: _phoneController,
                hint: '+221 XX XXX XX XX',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                prefixWidget: Container(
                  margin: const EdgeInsets.only(left: 12, right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.greenLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('🇸🇳',
                      style: TextStyle(fontSize: 16)),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Veuillez entrer un numéro';
                  if (v.replaceAll(' ', '').length < 9) return 'Numéro invalide';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Montant ──
              const _SectionLabel('Montant (FCFA)'),
              const SizedBox(height: 8),
              _InputField(
                controller: _amountController,
                hint: '0',
                icon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffixText: 'FCFA',
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Veuillez entrer un montant';
                  final amount = int.tryParse(v) ?? 0;
                  if (amount < 100) return 'Montant minimum : 100 FCFA';
                  return null;
                },
              ),

              const SizedBox(height: 8),

              // ── Raccourcis montants ──
              Wrap(
                spacing: 8,
                children: [1000, 5000, 10000, 25000].map((v) {
                  final isSelected = _parsedAmount == v;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _amountController.text = '$v'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        // ✅ Raccourci sélectionné mis en surbrillance
                        color: isSelected
                            ? AppColors.greenLight
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.green
                              : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        formatAmount(v),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? AppColors.greenDark
                              : AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // ── Note optionnelle ──
              const _SectionLabel('Note (optionnel)'),
              const SizedBox(height: 8),
              _InputField(
                controller: _noteController,
                hint: 'Loyer, remboursement...',
                icon: Icons.notes_outlined,
                maxLines: 2,
              ),

              const SizedBox(height: 24),

              // ── Récapitulatif ── ✅ mis à jour en temps réel
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: hasAmount ? AppColors.green : AppColors.border,
                    width: hasAmount ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    _RecapRow(
                      label: 'Montant',
                      value: hasAmount ? formatAmount(_parsedAmount) : '—',
                    ),
                    const SizedBox(height: 8),
                    const _RecapRow(label: 'Frais', value: '1 FCFA'),
                    const Divider(color: AppColors.border, height: 16),
                    _RecapRow(
                      label: 'Total',
                      value: hasAmount ? formatAmount(_parsedAmount) : '—',
                      bold: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Bouton envoyer ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.greenLight,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 6,
                    shadowColor: AppColors.green.withOpacity(0.4),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'ENVOYER',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2),
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────
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
        letterSpacing: 0.2,
      ),
    );
  }
}

// ── Input Field ───────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? prefixWidget;
  final String? suffixText;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.prefixWidget,
    this.suffixText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.text, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.sub, fontSize: 13),
        prefixIcon:
            prefixWidget ?? Icon(icon, color: AppColors.sub, size: 20),
        suffixText: suffixText,
        suffixStyle: const TextStyle(
            color: AppColors.sub,
            fontSize: 13,
            fontWeight: FontWeight.w600),
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.green, width: 1.8)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.red, width: 1.8)),
      ),
    );
  }
}

// ── Récapitulatif Row ─────────────────────────────────────────────────────────
class _RecapRow extends StatelessWidget {
  final String label, value;
  final bool bold;

  const _RecapRow(
      {required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 13, color: AppColors.sub)),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: bold ? AppColors.green : AppColors.text,
          ),
        ),
      ],
    );
  }
}

// ── Feuille Succès ────────────────────────────────────────────────────────────
class _SuccessSheet extends StatelessWidget {
  final String name;
  final int amount;
  final VoidCallback onClose;

  const _SuccessSheet(
      {required this.name,
      required this.amount,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
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
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(height: 28),
          Container(
            width: 72, height: 72,
            decoration: const BoxDecoration(
                color: AppColors.greenLight, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded,
                color: AppColors.greenDark, size: 38),
          ),
          const SizedBox(height: 16),
          const Text('Transfert réussi !',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text)),
          const SizedBox(height: 8),
          Text(
            '${formatAmount(amount)} envoyé à $name',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13, color: AppColors.sub, height: 1.5),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('TERMINER',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, letterSpacing: 1.5)),
            ),
          ),
        ],
      ),
    );
  }
}
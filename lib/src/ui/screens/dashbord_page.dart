import 'package:flutter/material.dart';
import 'package:terangapay/models/user_model.dart';
import 'package:terangapay/models/transaction_model.dart';
import '../../../app_theme.dart';
import 'history_page.dart' hide AppColors, TransactionType, Transaction, sampleTransactions;
import 'profile_page.dart';
import 'transfert_page.dart';

class DashboardPage extends StatefulWidget {
  final UserModel currentUser;

  const DashboardPage({super.key, required this.currentUser});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String formatAmount(double amount) => '${amount.toStringAsFixed(0)} FCFA';

  @override
  Widget build(BuildContext context) {
    final recent = sampleTransactions.take(4).toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ───────── HEADER ─────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  children: [
                    const Icon(Icons.menu, color: AppColors.sub, size: 24),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProfilePage(currentUser: widget.currentUser),
                        ),
                      ),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.currentUser.prenom[0]}${widget.currentUser.nom[0]}'.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// ───────── BIENVENUE ─────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Text(
                  'Bienvenue ${widget.currentUser.prenom},',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),

              /// ───────── CARTE SOLDE ─────────
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Solde Total',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatAmount(widget.currentUser.solde),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(width: double.infinity, height: 1, color: Colors.white24),
                    const SizedBox(height: 10),
                    Text(
                      widget.currentUser.telephone,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),

              /// ───────── ACTIONS RAPIDES ─────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _QuickAction(
                      icon: Icons.arrow_upward_rounded,
                      label: 'Transfert',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TransfertPage(
                            currentUser: widget.currentUser,
                            onTransactionUpdate: () => setState(() {}),
                          ),
                        ),
                      ),
                    ),
                    _QuickAction(
                      icon: Icons.history_rounded,
                      label: 'Historique',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HistoryPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ───────── TRANSACTIONS RÉCENTES ─────────
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  'Transactions récentes',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.text),
                ),
              ),

              ...recent.map((tx) => _DashboardTxRow(tx: tx)),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// ───────── QUICK ACTION ─────────
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.greenLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.greenDark, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text)),
        ],
      ),
    );
  }
}

/// ───────── TRANSACTION ROW ─────────
class _DashboardTxRow extends StatelessWidget {
  final Transaction tx;

  const _DashboardTxRow({required this.tx});

  bool get _isSend => tx.type == TransactionType.send;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isSend ? AppColors.redLight : AppColors.greenLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isSend ? Icons.arrow_upward : Icons.arrow_downward,
              color: _isSend ? AppColors.red : AppColors.greenDark,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tx.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text),
            ),
          ),
          Text(
            '${_isSend ? '-' : '+'}${tx.amount.toStringAsFixed(0)} FCFA',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _isSend ? AppColors.red : AppColors.greenDark,
            ),
          ),
        ],
      ),
    );
  }
}
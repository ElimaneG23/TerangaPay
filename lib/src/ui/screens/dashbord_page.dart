import 'package:flutter/material.dart';
import 'package:terangapay/src/ui/screens/history_page.dart'
    show AppColors, Transaction, TransactionType, sampleTransactions, formatAmount, HistoryPage;
import 'package:terangapay/src/ui/screens/profile_page.dart';
import 'package:terangapay/src/ui/screens/transfert_page.dart';

// ── Modèle User ───────────────────────────────────────────────────────────────
class User {
  final String prenom;
  final String nom;
  final String telephone;
  String get email => '$prenom.${nom.isNotEmpty ? nom[0] : ''}@gmail.com'.toLowerCase();
  final int solde;

  const User({
    required this.prenom,
    required this.nom,
    required this.telephone,
    required this.solde,
  });

  String get initials =>
      '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}'
          .toUpperCase();
}

// ── Helpers ───────────────────────────────────────────────────────────────────
String formatFullDate(DateTime date) {
  final months = [
    '', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
    'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
  ];
  final h = date.hour.toString().padLeft(2, '0');
  final m = date.minute.toString().padLeft(2, '0');
  return '${date.day} ${months[date.month]} ${date.year} · $h:$m';
}

// ─────────────────────────────────────────
//  DASHBOARD PAGE
// ─────────────────────────────────────────
class DashboardPage extends StatelessWidget {
  final User currentUser;

  const DashboardPage({super.key, required this.currentUser});

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
              // ── Header ──
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  children: [
                    const Icon(Icons.menu, color: AppColors.sub, size: 24),
                    const Spacer(),
                    GestureDetector(
                      // ✅ currentUser passé à ProfilePage
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfilePage(currentUser: currentUser),
                        ),
                      ),
                      child: Container(
                        width: 38, height: 38,
                        decoration: const BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          currentUser.initials,
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

              // ── Bienvenue ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  'Bienvenue ${currentUser.prenom},',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),

              // ── Balance Card ──
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4ECBA1), Color(0xFF3AB88E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Solde Total',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          formatAmount(currentUser.solde),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.remove_red_eye_outlined,
                            color: Colors.white70, size: 18),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(width: double.infinity, height: 1, color: Colors.white24),
                    const SizedBox(height: 12),
                    Text(currentUser.telephone,
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),

              // ── Actions rapides ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _QuickAction(
                      icon: Icons.arrow_upward_rounded,
                      label: 'Transfert',
                      // ✅ TransfertPage fonctionne — plus de 'hide'
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TransfertPage()),
                      ),
                    ),
                    _QuickAction(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Payer',
                      onTap: () {},
                    ),
                    _QuickAction(
                      icon: Icons.history_rounded,
                      label: 'Historique',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryPage()),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Transactions récentes ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Historique',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        )),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryPage()),
                      ),
                      child: const Text('Voir tout',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ),
              ),

              // ── Liste transactions ──
              if (recent.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text('Aucune transaction récente',
                        style: TextStyle(color: AppColors.sub, fontSize: 13)),
                  ),
                )
              else
                ...recent.map((tx) => _DashboardTxRow(tx: tx)),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick Action Button ───────────────────────────────────────────────────────
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: AppColors.greenLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.greenDark, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              )),
        ],
      ),
    );
  }
}

// ── Dashboard Transaction Row ─────────────────────────────────────────────────
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
            width: 40, height: 40,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isSend ? 'Envoyé à ${tx.name}' : 'Reçu de ${tx.name}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(formatFullDate(tx.date),
                    style: const TextStyle(fontSize: 10, color: AppColors.sub)),
              ],
            ),
          ),
          Text(
            '${_isSend ? '-' : '+'}${formatAmount(tx.amount)}',
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
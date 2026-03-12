import 'package:flutter/material.dart';
import '../../../app_theme.dart';

// ── Modèle Transaction ────────────────────────────────────────────────────────
enum TransactionType { send, receive }

class Transaction {
  final String name;
  final String reference;
  final int amount;
  final TransactionType type;
  final String status;
  final DateTime date;

  const Transaction({
    required this.name,
    required this.reference,
    required this.amount,
    required this.type,
    required this.status,
    required this.date,
  });
}

// ── Stockage des transactions par utilisateur (téléphone → liste) ──────────
// Les utilisateurs chargés depuis users.json ont leurs transactions initiales ici.
// Les nouveaux inscrits démarrent avec une liste vide (aucune entrée dans la Map).
final Map<String, List<Transaction>> _transactionsByUser = {
  '771234567': [
    Transaction(name: 'Abdoulaye B.', reference: 'TERANGA-123456789', amount: 5000, type: TransactionType.send,    status: 'completed', date: DateTime.now()),
    Transaction(name: 'Fatou Diallo',  reference: 'TERANGA-987654321', amount: 3000, type: TransactionType.receive, status: 'completed', date: DateTime.now()),
    Transaction(name: 'Moussa Sy',     reference: 'TERANGA-111222333', amount: 2000, type: TransactionType.send,    status: 'pending',   date: DateTime.now().subtract(const Duration(days: 1))),
  ],
};

/// Retourne la liste de transactions de l'utilisateur (vide si nouveau)
List<Transaction> getTransactionsForUser(String telephone) {
  return _transactionsByUser.putIfAbsent(telephone, () => []);
}

/// Ajoute une transaction pour un utilisateur donné
void addTransactionForUser(String telephone, Transaction tx) {
  _transactionsByUser.putIfAbsent(telephone, () => []).insert(0, tx);
}

// Alias de rétrocompatibilité — ne plus utiliser directement
List<Transaction> sampleTransactions = [];

String formatAmount(int amount) => '$amount FCFA';

// ─────────────────────────────────────────
//  HISTORY PAGE
// ─────────────────────────────────────────
class HistoryPage extends StatelessWidget {
  final String telephone;

  const HistoryPage({super.key, required this.telephone});

  List<Transaction> get _userTransactions => getTransactionsForUser(telephone);

  int get _totalRecu => _userTransactions
      .where((t) => t.type == TransactionType.receive)
      .fold(0, (s, t) => s + t.amount);

  int get _totalEnvoye => _userTransactions
      .where((t) => t.type == TransactionType.send)
      .fold(0, (s, t) => s + t.amount);

  Map<String, List<Transaction>> _groupByDate(List<Transaction> txs) {
    final map = <String, List<Transaction>>{};
    for (final tx in txs) {
      final now = DateTime.now();
      String label;
      final diff = now.difference(tx.date).inDays;
      if (diff == 0) label = "Aujourd'hui";
      else if (diff == 1) label = 'Hier';
      else label = '${tx.date.day}/${tx.date.month}/${tx.date.year}';
      map.putIfAbsent(label, () => []).add(tx);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate(_userTransactions);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            title: const Text(
              'Historique',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Résumé ──
          Container(
            margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  _SummaryItem(
                    icon: Icons.arrow_downward_rounded,
                    iconBg: AppColors.greenLight,
                    iconColor:  AppColors.green,
                    label: 'Reçu',
                    value: '+${formatAmount(_totalRecu)}',
                    valueColor:  AppColors.green,
                  ),
                  Container(
                    width: 1,
                    color: AppColors.border,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  _SummaryItem(
                    icon: Icons.arrow_upward_rounded,
                    iconBg: AppColors.redLight,
                    iconColor: AppColors.red,
                    label: 'Envoyé',
                    value: '-${formatAmount(_totalEnvoye)}',
                    valueColor: AppColors.red,
                  ),
                  Container(
                    width: 1,
                    color: AppColors.border,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  _SummaryItem(
                    icon: Icons.swap_horiz_rounded,
                    iconBg: AppColors.greenLight,
                    iconColor:  AppColors.primary,
                    label: 'Total',
                    value: '${_userTransactions.length} opér.',
                    valueColor:  AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          // ── Liste transactions ──
          Expanded(
            child: grouped.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.greenLight,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.inbox_rounded,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Aucune transaction',
                    style: TextStyle(
                      color: AppColors.sub,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: grouped.length,
              itemBuilder: (context, i) {
                final label = grouped.keys.elementAt(i);
                final txs = grouped[label]!;
                return _DateGroup(
                  label: label,
                  transactions: txs,
                  onTap: (tx) => _showDetail(context, tx),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Transaction tx) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DetailSheet(tx: tx),
    );
  }
}

// ── Summary Item ──────────────────────────────────────────────────────────────
class _SummaryItem extends StatelessWidget {
  final String label, value;
  final Color valueColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.sub,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date Group ────────────────────────────────────────────────────────────────
class _DateGroup extends StatelessWidget {
  final String label;
  final List<Transaction> transactions;
  final void Function(Transaction) onTap;

  const _DateGroup({
    required this.label,
    required this.transactions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.sub,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.border,
                ),
              ),
            ],
          ),
        ),
        ...transactions.map((tx) => _TxCard(tx: tx, onTap: () => onTap(tx))),
      ],
    );
  }
}

// ── Transaction Card ──────────────────────────────────────────────────────────
class _TxCard extends StatelessWidget {
  final Transaction tx;
  final VoidCallback onTap;

  const _TxCard({required this.tx, required this.onTap});

  bool get _isSend => tx.type == TransactionType.send;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isSend
                    ? AppColors.redLight
                    : AppColors.greenLight,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                _isSend
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: _isSend ? AppColors.red :  AppColors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        tx.reference.split('-').last,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.sub,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _StatusBadge(status: tx.status, small: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_isSend ? '-' : '+'}${formatAmount(tx.amount)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _isSend ? AppColors.red :  AppColors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${tx.date.hour.toString().padLeft(2, '0')}:${tx.date.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.sub,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.border,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  final bool small;

  const _StatusBadge({required this.status, this.small = false});

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == 'completed';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 7 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.greenLight
            : AppColors.yellowLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: small ? 5 : 6,
            height: small ? 5 : 6,
            decoration: BoxDecoration(
              color: isCompleted
                  ?  AppColors.green
                  : AppColors.yellow,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isCompleted ? 'Réussi' : 'En attente',
            style: TextStyle(
              fontSize: small ? 9 : 11,
              fontWeight: FontWeight.w700,
              color: isCompleted
                  ?  AppColors.green
                  : AppColors.yellow,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Detail Bottom Sheet ───────────────────────────────────────────────────────
class _DetailSheet extends StatelessWidget {
  final Transaction tx;

  const _DetailSheet({required this.tx});

  bool get _isSend => tx.type == TransactionType.send;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 28),

          // Icône + montant
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: _isSend
                  ? const LinearGradient(
                colors: [AppColors.red, AppColors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : const LinearGradient(
                colors: [AppColors.green, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isSend ? AppColors.red :  AppColors.green)
                      .withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              _isSend ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),

          Text(
            _isSend ? 'Envoyé à ${tx.name}' : 'Reçu de ${tx.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isSend ? 'Transfert sortant' : 'Transfert entrant',
            style: const TextStyle(fontSize: 12, color: AppColors.sub),
          ),
          const SizedBox(height: 12),

          Text(
            '${_isSend ? '-' : '+'}${formatAmount(tx.amount)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: _isSend ? AppColors.red :  AppColors.green,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 22),

          // Carte détails
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _DetailRow(label: 'Référence', value: tx.reference),
                _DetailRow(
                  label: 'Statut',
                  child: _StatusBadge(status: tx.status, small: false),
                ),
                _DetailRow(label: 'Montant', value: formatAmount(tx.amount)),
                _DetailRow(label: 'Frais', value: '0 FCFA'),
                _DetailRow(
                  label: 'Total',
                  value:
                  '${_isSend ? '-' : '+'}${formatAmount(tx.amount)}',
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Fermer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.4,
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

// ── Detail Row ────────────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? child;
  final bool isLast;

  const _DetailRow({
    required this.label,
    this.value,
    this.child,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.sub,
              fontWeight: FontWeight.w500,
            ),
          ),
          child ??
              Text(
                value ?? '',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
        ],
      ),
    );
  }
}
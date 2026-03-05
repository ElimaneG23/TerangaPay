import 'package:flutter/material.dart';
import '../../../app_theme.dart';


// ── Couleurs (remplace app_theme.dart si besoin) ───────────────────────────

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

// Données exemples
final List<Transaction> sampleTransactions = [
  Transaction(name: 'Abdoulaye B.', reference: 'TERANGA-123456789', amount: 5000, type: TransactionType.send,    status: 'completed', date: DateTime.now()),
  Transaction(name: 'Fatou Diallo',  reference: 'TERANGA-987654321', amount: 3000, type: TransactionType.receive, status: 'completed', date: DateTime.now()),
  Transaction(name: 'Moussa Sy',     reference: 'TERANGA-111222333', amount: 2000, type: TransactionType.send,    status: 'pending',   date: DateTime.now().subtract(const Duration(days: 1))),
];

String formatAmount(int amount) => '$amount FCFA';

// ─────────────────────────────────────────
//  HISTORY PAGE
// ─────────────────────────────────────────
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  int get _totalRecu => sampleTransactions
      .where((t) => t.type == TransactionType.receive)
      .fold(0, (s, t) => s + t.amount);

  int get _totalEnvoye => sampleTransactions
      .where((t) => t.type == TransactionType.send)
      .fold(0, (s, t) => s + t.amount);

  // Groupe les transactions par date
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
    final grouped = _groupByDate(sampleTransactions);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: BackButton(color: AppColors.primary),
        ),
        title: Text('Historique', style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w700)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color.fromARGB(255, 234, 221, 211), height: 1),
        ),
      ),
      body: Column(
        children: [
          // ── Résumé ──
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 38, 207, 108).withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  _SummaryItem(
                    label: 'Reçu',
                    value: '+${formatAmount(_totalRecu)}',
                    valueColor: AppColors.greenDark,
                  ),
                  const VerticalDivider(color: AppColors.border, width: 1, thickness: 1),
                  _SummaryItem(
                    label: 'Envoyé',
                    value: '-${formatAmount(_totalEnvoye)}',
                    valueColor: AppColors.red,
                  ),
                  const VerticalDivider(color: AppColors.border, width: 1, thickness: 1),
                  _SummaryItem(
                    label: 'Total',
                    value: '${sampleTransactions.length} opér.',
                    valueColor: AppColors.text,
                  ),
                ],
              ),
            ),
          ),

          // ── Liste transactions ──
          Expanded(
            child: grouped.isEmpty
                ? const Center(child: Text('Aucune transaction', style: TextStyle(color: AppColors.sub)))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
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

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 10, color: AppColors.sub, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: valueColor),
              textAlign: TextAlign.center),
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
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.sub,
                  letterSpacing: 0.5)),
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
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            // ✅ Correction : _isSend ? ... : ... correctement écrit
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: _isSend ? AppColors.redLight : AppColors.greenLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isSend ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                color: _isSend ? AppColors.red : AppColors.greenDark,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.name,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(tx.reference.split('-').last,
                          style: const TextStyle(fontSize: 10, color: AppColors.sub)),
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
                      fontWeight: FontWeight.w700,
                      color: _isSend ? AppColors.red : AppColors.greenDark),
                ),
                const SizedBox(height: 3),
                Text(
                  '${tx.date.hour.toString().padLeft(2, '0')}:${tx.date.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 10, color: AppColors.sub),
                ),
              ],
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
      padding: EdgeInsets.symmetric(horizontal: small ? 6 : 10, vertical: small ? 2 : 4),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.greenLight : const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isCompleted ? 'Réussi' : 'En attente',
        style: TextStyle(
          fontSize: small ? 9 : 11,
          fontWeight: FontWeight.w600,
          color: isCompleted ? AppColors.greenDark : const Color(0xFF856404),
        ),
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
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),

          // ✅ Correction : Container fermé correctement
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: _isSend ? AppColors.redLight : AppColors.greenLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isSend ? Icons.arrow_upward : Icons.arrow_downward,
              color: _isSend ? AppColors.red : AppColors.greenDark,
              size: 26,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            _isSend ? 'Envoyé à ${tx.name}' : 'Reçu de ${tx.name}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.text),
          ),
          const SizedBox(height: 4),
          Text(
            _isSend ? 'Transfert envoyé' : 'Transfert reçu',
            style: const TextStyle(fontSize: 12, color: AppColors.sub),
          ),
          const SizedBox(height: 14),

          Text(
            '${_isSend ? '-' : '+'}${formatAmount(tx.amount)}',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: _isSend ? AppColors.red : AppColors.greenDark,
            ),
          ),
          const SizedBox(height: 18),

          _DetailRow(label: 'Référence', value: tx.reference),
          _DetailRow(label: 'Statut', child: _StatusBadge(status: tx.status, small: false)),
          _DetailRow(label: 'Montant', value: formatAmount(tx.amount)),
          _DetailRow(label: 'Frais', value: '0 FCFA'),
          _DetailRow(label: 'Total', value: '${_isSend ? '-' : '+'}${formatAmount(tx.amount)}', isLast: true),

          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: const Color(0xFFF5E6D0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Fermer', style: TextStyle(fontWeight: FontWeight.bold)),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: AppColors.sub, fontWeight: FontWeight.w500)),
          child ??
              Text(value ?? '',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text)),
        ],
      ),
    );
  }
}
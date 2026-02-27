enum TransactionType { send, receive }

class Transaction {
  final String name;
  final double amount;
  final TransactionType type;

  Transaction({
    required this.name,
    required this.amount,
    required this.type,
  });
}

final List<Transaction> sampleTransactions = [
  Transaction(
    name: "Mamadou Diallo",
    amount: 15000,
    type: TransactionType.send,
  ),
  Transaction(
    name: "Fatou Ndiaye",
    amount: 20000,
    type: TransactionType.receive,
  ),
  Transaction(
    name: "Senelec",
    amount: 12000,
    type: TransactionType.send,
  ),
];
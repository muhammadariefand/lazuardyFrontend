class PayoutEntity {
  final int id;
  final String payoutNumber;
  final double amount;
  final String bankCode;
  final String accountHolderName;
  final String accountNumber;
  final String status;
  final String? xenditId;
  final DateTime createdAt;

  PayoutEntity({
    required this.id,
    required this.payoutNumber,
    required this.amount,
    required this.bankCode,
    required this.accountHolderName,
    required this.accountNumber,
    required this.status,
    this.xenditId,
    required this.createdAt,
  });
}

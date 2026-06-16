import 'package:lazuadry_mobile_fe/domain/entities/payout_entity.dart';

class PayoutModel extends PayoutEntity {
  PayoutModel({
    required super.id,
    required super.payoutNumber,
    required super.amount,
    required super.bankCode,
    required super.accountHolderName,
    required super.accountNumber,
    required super.status,
    super.xenditId,
    required super.createdAt,
  });

  factory PayoutModel.fromJson(Map<String, dynamic> json) {
    return PayoutModel(
      id: json['id'],
      payoutNumber: json['payout_number'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      bankCode: json['bank_code'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      status: json['status'] ?? 'pending',
      xenditId: json['xendit_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}

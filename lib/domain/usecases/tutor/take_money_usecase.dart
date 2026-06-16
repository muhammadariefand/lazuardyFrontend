import 'package:lazuadry_mobile_fe/domain/repositories/tarik_saldo_repository.dart';

class TakeMoneyUseCase {
  final TarikSaldoRepository repository;

  TakeMoneyUseCase(this.repository);

  Future<void> call({
    required double amount,
    required String bankAccountId,
    required String note,
  }) {
    return repository.takeMoney(
      amount: amount,
      bankAccountId: bankAccountId,
      note: note,
    );
  }
}

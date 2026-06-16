import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/payout_entity.dart';

abstract class TarikSaldoRepository {
  Future<PaginatedDataEntity<PayoutEntity>> getPayoutHistory({
    String? status,
    int? page,
    int perPage = 10,
  });

  Future<void> takeMoney({
    required double amount,
    required String bankAccountId,
    required String note,
  });
}

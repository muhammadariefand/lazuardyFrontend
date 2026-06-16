import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/payout_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tarik_saldo_repository.dart';

class GetPayoutHistoryUseCase {
  final TarikSaldoRepository repository;

  GetPayoutHistoryUseCase(this.repository);

  Future<PaginatedDataEntity<PayoutEntity>> call({
    String? status,
    int? page,
    int perPage = 10,
  }) {
    return repository.getPayoutHistory(
      status: status,
      page: page,
      perPage: perPage,
    );
  }
}

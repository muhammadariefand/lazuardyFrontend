import 'package:lazuadry_mobile_fe/data/datasources/tarik_saldo_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/models/payout_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/payout_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tarik_saldo_repository.dart';

class TarikSaldoRepositoryImpl implements TarikSaldoRepository {
  final TarikSaldoRemoteDataSource remoteDataSource;

  TarikSaldoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedDataEntity<PayoutEntity>> getPayoutHistory({
    String? status,
    int? page,
    int perPage = 10,
  }) async {
    try {
      final responseMap = await remoteDataSource.getPayoutHistory(
        status: status,
        page: page,
        perPage: perPage,
      );

      final itemsData = responseMap['items'] as List<dynamic>? ?? [];
      final items = itemsData
          .map((item) => PayoutModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return PaginatedDataEntity<PayoutEntity>(
        data: items,
        currentPage: responseMap['current_page'] as int? ?? 1,
        lastPage: (responseMap['total'] as int? ?? 0) > 0 
            ? ((responseMap['total'] as int) / perPage).ceil() 
            : 1, // Jika response dari backend beda dengan standard Laravel (contoh JSON cuma ada total dan per_page)
        total: responseMap['total'] as int? ?? 0,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga saat mengambil histori penarikan.');
    }
  }

  @override
  Future<void> takeMoney({
    required double amount,
    required String bankAccountId,
    required String note,
  }) async {
    try {
      await remoteDataSource.takeMoney(
        amount: amount,
        bankAccountId: bankAccountId,
        note: note,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga saat meminta penarikan dana.');
    }
  }
}

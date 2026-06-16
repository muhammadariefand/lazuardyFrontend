import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';

abstract class TarikSaldoRemoteDataSource {
  Future<Map<String, dynamic>> getPayoutHistory({
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

class TarikSaldoRemoteDataSourceImpl implements TarikSaldoRemoteDataSource {
  final Dio dio;

  TarikSaldoRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getPayoutHistory({
    String? status,
    int? page,
    int perPage = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (status != null) 'status': status,
        if (page != null) 'page': page,
        'per_page': perPage,
      };

      final response = await dio.get(
        '/tutor/payout/history',
        queryParameters: queryParams,
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status']?.toString().toLowerCase() == 'success' &&
          responseData['data'] != null) {
        return responseData['data'] as Map<String, dynamic>;
      }
      throw ServerException('Format respon riwayat penarikan tidak valid');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException('Akses ditolak: Hanya tutor yang dapat mengakses data ini');
      }
      String errorMessage = 'Terjadi kesalahan pada server saat mengambil histori penarikan';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      throw ServerException(errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }

  @override
  Future<void> takeMoney({
    required double amount,
    required String bankAccountId,
    required String note,
  }) async {
    try {
      final response = await dio.post(
        '/tutor/take-money',
        data: {
          'amount': amount,
          'bank_account_id': bankAccountId,
          'note': note,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status']?.toString().toLowerCase() != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal membuat permintaan penarikan');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 400 || e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map && data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final messages = errors.values
              .expand((v) => v is List ? v : [v])
              .map((e) => e.toString())
              .join('\n');
          throw ServerException(messages);
        }
        throw ServerException(data?['message'] ?? 'Validasi request gagal');
      }
      String errorMessage = 'Terjadi kesalahan pada server saat memproses penarikan';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      throw ServerException(errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }
}

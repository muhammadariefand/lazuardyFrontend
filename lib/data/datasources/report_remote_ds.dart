import 'package:dio/dio.dart';
import '../models/report_model.dart';
import '../models/paginated_data_model.dart';
import '../../domain/entities/server_exception.dart';

abstract class ReportRemoteDataSource {
  Future<PaginatedDataModel<ReportModel>> getReports({
    required int page,
  });
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final Dio dio;

  ReportRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaginatedDataModel<ReportModel>> getReports({
    required int page,
  }) async {
    try {
      final response = await dio.get(
        '/reports',
        queryParameters: {
          'page': page,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status']?.toString().toLowerCase() == 'success') {
        final dataMap = responseData['data'] as Map<String, dynamic>?;
        if (dataMap != null) {
          final rawList = dataMap['data'] as List<dynamic>? ?? [];
          final reports = rawList
              .map((item) => ReportModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return PaginatedDataModel<ReportModel>.fromJson(dataMap, reports);
        }
      }
      throw ServerException(responseData['message'] ?? 'Format respon laporan tidak valid');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      String errorMessage = 'Terjadi kesalahan pada server';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] 
            ?? e.response?.data['error'] 
            ?? errorMessage;
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      throw ServerException(errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }
}

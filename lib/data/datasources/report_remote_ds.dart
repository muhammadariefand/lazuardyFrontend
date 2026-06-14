import 'package:dio/dio.dart';
import '../models/report_model.dart';
import '../models/paginated_data_model.dart';

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
    final response = await dio.get(
      '/reports',
      queryParameters: {
        'page': page,
      },
    );

    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;

      // Cek status sukses dari backend
      final status = responseData['status']?.toString().toLowerCase();
      if (status == 'success' || responseData['data'] != null) {
        final dataMap = responseData['data'] as Map<String, dynamic>?;
        if (dataMap != null) {
          final rawList = dataMap['data'] as List<dynamic>? ?? [];
          final reports = rawList
              .map((item) => ReportModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return PaginatedDataModel<ReportModel>.fromJson(dataMap, reports);
        }
      }
    }

    throw Exception('Format respon laporan tidak valid');
  }
}

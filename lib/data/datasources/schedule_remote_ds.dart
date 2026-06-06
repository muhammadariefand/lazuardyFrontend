import 'package:dio/dio.dart';
import '../models/schedule_model.dart';
import '../models/paginated_data_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<PaginatedDataModel<ScheduleModel>> getSchedules({
    required String status,
    required String date,
    int page = 1,
  });
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final Dio dio;

  ScheduleRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaginatedDataModel<ScheduleModel>> getSchedules({
    required String status,
    required String date,
    int page = 1,
  }) async {
    final response = await dio.get(
      '/schedules',
      queryParameters: {
        'status': status,
        'date': date,
        'page': page,
      },
    );

    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;
      final dataMap = responseData['data'] as Map<String, dynamic>?;
      if (dataMap != null) {
        final rawList = dataMap['data'] as List<dynamic>? ?? [];
        final schedules = rawList
            .map((item) => ScheduleModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return PaginatedDataModel<ScheduleModel>.fromJson(dataMap, schedules);
      }
    }

    throw Exception('Format respon jadwal tidak valid');
  }
}

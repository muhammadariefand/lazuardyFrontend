import 'package:dio/dio.dart';
import '../models/schedule_model.dart';
import '../models/paginated_data_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<PaginatedDataModel<ScheduleModel>> getSchedules({
    required String status,
    required String date,
    int page = 1,
  });

  /// PATCH /tutor/schedule/booking-confirmation
  Future<void> confirmBooking({
    required int scheduleId,
    required String decision,
    String? urlMeeting,
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
    final queryParams = <String, dynamic>{
      'page': page,
    };
    // Hanya kirim status jika tidak kosong
    if (status.isNotEmpty) {
      queryParams['status'] = status;
    }
    // Hanya kirim date jika tidak kosong
    if (date.isNotEmpty) {
      queryParams['date'] = date;
    }

    final response = await dio.get(
      '/schedules',
      queryParameters: queryParams,
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

  @override
  Future<void> confirmBooking({
    required int scheduleId,
    required String decision,
    String? urlMeeting,
  }) async {
    final Map<String, dynamic> data = {
      'schedule_id': scheduleId,
      'decision': decision,
    };
    if (urlMeeting != null && urlMeeting.isNotEmpty) {
      data['url_meeting'] = urlMeeting;
    }
    await dio.patch(
      '/tutor/schedule/booking-confirmation',
      data: data,
    );
  }
}

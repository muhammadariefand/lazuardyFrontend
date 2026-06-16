import 'package:dio/dio.dart';
import '../models/schedule_model.dart';
import '../models/paginated_data_model.dart';
import '../../domain/entities/server_exception.dart';

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

    try {
      final response = await dio.get(
        '/schedules',
        queryParameters: queryParams,
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status'] == 'success') {
        final dataMap = responseData['data'] as Map<String, dynamic>?;
        if (dataMap != null) {
          final rawList = dataMap['data'] as List<dynamic>? ?? [];
          final schedules = rawList
              .map((item) => ScheduleModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return PaginatedDataModel<ScheduleModel>.fromJson(dataMap, schedules);
        }
      }
      throw ServerException(responseData['message'] ?? 'Format respon jadwal tidak valid');
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

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

  /// GET /schedule/getById?schedule_id={id}
  Future<ScheduleModel> getScheduleById(int scheduleId);

  /// PATCH /student/schedule/mark-as-complete
  Future<void> markScheduleComplete(int scheduleId);

  /// POST /student/review/create
  Future<void> submitReview({
    required int tutorId,
    required double rate,
    required String comment,
  });

  /// POST /schedule/cancel
  Future<void> cancelSchedule({
    required int scheduleId,
    required String reason,
  });

  /// POST /tutor/presence/create
  Future<void> createPresence({
    required int scheduleId,
    required String topic,
    required String notes,
  });
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final Dio dio;

  ScheduleRemoteDataSourceImpl({required this.dio});

  String _extractMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return fallback;
  }

  @override
  Future<PaginatedDataModel<ScheduleModel>> getSchedules({
    required String status,
    required String date,
    int page = 1,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
    };
    if (status.isNotEmpty) {
      queryParams['status'] = status;
    }
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
      throw ServerException(_extractMessage(e, 'Terjadi kesalahan pada server'));
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

  @override
  Future<ScheduleModel> getScheduleById(int scheduleId) async {
    try {
      final response = await dio.get(
        '/schedule/getById',
        queryParameters: {'schedule_id': scheduleId},
      );
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        return ScheduleModel.fromJson(data);
      }
      throw ServerException(responseData['message'] ?? 'Gagal mengambil detail sesi');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 404) {
        throw ServerException('Data sesi tidak ditemukan');
      }
      throw ServerException(_extractMessage(e, 'Terjadi kesalahan saat memuat detail sesi'));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<void> markScheduleComplete(int scheduleId) async {
    try {
      final response = await dio.patch(
        '/student/schedule/mark-as-complete',
        data: {'schedule_id': scheduleId},
      );
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status'] != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal menandai sesi selesai');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException('Anda tidak memiliki akses untuk aksi ini');
      }
      throw ServerException(_extractMessage(e, 'Terjadi kesalahan saat konfirmasi selesai'));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<void> submitReview({
    required int tutorId,
    required double rate,
    required String comment,
  }) async {
    try {
      final response = await dio.post(
        '/student/review/create',
        data: {
          'tutor_id': tutorId,
          'rate': rate,
          'comment': comment,
        },
      );
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status'] != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal mengirim rating');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException('Hanya siswa yang dapat memberikan rating');
      }
      throw ServerException(_extractMessage(e, 'Terjadi kesalahan saat mengirim rating'));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<void> cancelSchedule({
    required int scheduleId,
    required String reason,
  }) async {
    try {
      final response = await dio.post(
        '/schedule/cancel',
        data: {
          'schedule_id': scheduleId,
          'reason': reason,
        },
      );
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status'] != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal membatalkan sesi');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException('Anda tidak memiliki akses untuk membatalkan sesi ini');
      }
      if (e.response?.statusCode == 404) {
        throw ServerException('Sesi tidak ditemukan');
      }
      throw ServerException(_extractMessage(e, 'Terjadi kesalahan saat membatalkan sesi'));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<void> createPresence({
    required int scheduleId,
    required String topic,
    required String notes,
  }) async {
    try {
      final response = await dio.post(
        '/tutor/presence/create',
        data: {
          'schedule_id': scheduleId,
          'topic': topic,
          'notes': notes,
        },
      );
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status'] != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal membuat laporan sesi');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException('Akses ditolak. Fitur ini hanya untuk Tutor.');
      }
      throw ServerException(_extractMessage(e, 'Terjadi kesalahan saat membuat laporan sesi'));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }
}

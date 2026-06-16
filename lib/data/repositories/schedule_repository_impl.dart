import 'package:dio/dio.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/entities/paginated_data_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/server_exception.dart';
import '../datasources/schedule_remote_ds.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  String _extractDioMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map && data.containsKey('message')) {
      return data['message'].toString();
    }
    return e.message ?? fallback;
  }

  @override
  Future<PaginatedDataEntity<ScheduleEntity>> getSchedules({
    required String status,
    required String date,
    int page = 1,
  }) async {
    try {
      return await remoteDataSource.getSchedules(
        status: status,
        date: date,
        page: page,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Unauthorized');
      }
      throw ServerException(_extractDioMessage(e, 'Gagal memuat jadwal'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan saat memuat jadwal');
    }
  }

  @override
  Future<void> confirmBooking({
    required int scheduleId,
    required String decision,
    String? urlMeeting,
  }) async {
    try {
      await remoteDataSource.confirmBooking(
        scheduleId: scheduleId,
        decision: decision,
        urlMeeting: urlMeeting,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Unauthorized');
      }
      throw ServerException(_extractDioMessage(e, 'Gagal mengonfirmasi booking'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan saat mengonfirmasi booking');
    }
  }

  @override
  Future<ScheduleEntity> getScheduleById(int scheduleId) async {
    try {
      return await remoteDataSource.getScheduleById(scheduleId);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Unauthorized');
      }
      throw ServerException(_extractDioMessage(e, 'Gagal memuat detail sesi'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan saat memuat detail sesi');
    }
  }

  @override
  Future<void> markScheduleComplete(int scheduleId) async {
    try {
      await remoteDataSource.markScheduleComplete(scheduleId);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Unauthorized');
      }
      throw ServerException(_extractDioMessage(e, 'Gagal menandai sesi selesai'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan saat menandai sesi selesai');
    }
  }

  @override
  Future<void> submitReview({
    required int tutorId,
    required double rate,
    required String comment,
  }) async {
    try {
      await remoteDataSource.submitReview(
        tutorId: tutorId,
        rate: rate,
        comment: comment,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Unauthorized');
      }
      throw ServerException(_extractDioMessage(e, 'Gagal mengirim rating'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan saat mengirim rating');
    }
  }
}

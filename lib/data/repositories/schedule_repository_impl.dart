import 'package:dio/dio.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/entities/paginated_data_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/server_exception.dart';
import '../datasources/schedule_remote_ds.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

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
      final data = e.response?.data;
      throw ServerException(
        data is Map && data.containsKey('message')
            ? data['message'].toString()
            : (e.message ?? 'Gagal memuat jadwal'),
      );
    } catch (e) {
      throw ServerException('Terjadi kesalahan saat memuat jadwal');
    }
  }
}

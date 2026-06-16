import 'package:lazuadry_mobile_fe/data/datasources/profil_mengajar_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/models/tutor_availability_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_availability_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/profil_mengajar_repository.dart';

class ProfilMengajarRepositoryImpl implements ProfilMengajarRepository {
  final ProfilMengajarRemoteDataSource remoteDataSource;

  ProfilMengajarRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedDataEntity<TutorAvailabilityEntity>> getTutorSchedules({
    required int tutorId,
    String? day,
  }) async {
    try {
      final responseMap = await remoteDataSource.getTutorSchedules(
        tutorId: tutorId,
        day: day,
      );

      final itemsData = responseMap['data'] as List<dynamic>? ?? [];
      final items = itemsData
          .map((item) => TutorAvailabilityModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return PaginatedDataEntity<TutorAvailabilityEntity>(
        data: items,
        currentPage: responseMap['current_page'] as int? ?? 1,
        lastPage: responseMap['last_page'] as int? ?? 1,
        total: responseMap['total'] as int? ?? 0,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga saat mengambil jadwal tutor.');
    }
  }

  @override
  Future<void> updateTeachingProfile({
    required String description,
    required List<String> learningMethods,
    required List<Map<String, String>> schedules,
  }) async {
    try {
      await remoteDataSource.updateTeachingProfile(
        description: description,
        learningMethods: learningMethods,
        schedules: schedules,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga saat memperbarui profil mengajar.');
    }
  }
}

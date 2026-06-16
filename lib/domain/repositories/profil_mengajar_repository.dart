import 'package:lazuadry_mobile_fe/domain/entities/tutor_availability_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';

abstract class ProfilMengajarRepository {
  Future<PaginatedDataEntity<TutorAvailabilityEntity>> getTutorSchedules({
    required int tutorId,
    String? day,
  });

  Future<void> updateTeachingProfile({
    required String description,
    required List<String> learningMethods,
    required List<Map<String, String>> schedules,
  });
}

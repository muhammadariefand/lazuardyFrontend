import 'package:lazuadry_mobile_fe/domain/entities/tutor_availability_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/profil_mengajar_repository.dart';

class GetTeachingSchedulesUseCase {
  final ProfilMengajarRepository repository;

  GetTeachingSchedulesUseCase(this.repository);

  Future<PaginatedDataEntity<TutorAvailabilityEntity>> execute({
    required int tutorId,
    String? day,
  }) {
    return repository.getTutorSchedules(
      tutorId: tutorId,
      day: day,
    );
  }
}

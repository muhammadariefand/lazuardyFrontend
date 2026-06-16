import 'package:lazuadry_mobile_fe/domain/repositories/profil_mengajar_repository.dart';

class UpdateTeachingProfileUseCase {
  final ProfilMengajarRepository repository;

  UpdateTeachingProfileUseCase(this.repository);

  Future<void> execute({
    required String description,
    required List<String> learningMethods,
    required List<Map<String, String>> schedules,
  }) {
    return repository.updateTeachingProfile(
      description: description,
      learningMethods: learningMethods,
      schedules: schedules,
    );
  }
}

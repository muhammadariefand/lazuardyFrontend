import '../../entities/tutor_entity.dart';
import '../../repositories/tutor_profile_repository.dart';

class GetTutorProfileUseCase {
  final TutorProfileRepository repository;

  GetTutorProfileUseCase(this.repository);

  Future<TutorEntity> execute() {
    return repository.getTutorProfile();
  }
}

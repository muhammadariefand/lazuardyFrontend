import '../../repositories/tutor_profile_repository.dart';

class UpdateTutorBiodataUseCase {
  final TutorProfileRepository repository;

  UpdateTutorBiodataUseCase(this.repository);

  Future<void> execute(Map<String, dynamic> data) {
    return repository.updateTutorBiodata(data);
  }
}

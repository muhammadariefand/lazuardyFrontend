import '../../repositories/tutor_profile_repository.dart';

class UpdateTutorProfilePhotoUseCase {
  final TutorProfileRepository repository;

  UpdateTutorProfilePhotoUseCase(this.repository);

  Future<void> execute(List<int> fileBytes, String fileName) {
    return repository.updateProfilePhoto(fileBytes, fileName);
  }
}

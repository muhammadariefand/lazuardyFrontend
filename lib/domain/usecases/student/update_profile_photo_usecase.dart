import 'package:lazuadry_mobile_fe/domain/repositories/student_repository.dart';

class UpdateProfilePhotoUseCase {
  final StudentRepository repository;

  UpdateProfilePhotoUseCase(this.repository);

  Future<void> execute(List<int> fileBytes, String fileName) {
    return repository.updateProfilePhoto(fileBytes, fileName);
  }
}

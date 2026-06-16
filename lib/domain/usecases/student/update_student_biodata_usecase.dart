import 'package:lazuadry_mobile_fe/domain/repositories/student_repository.dart';

class UpdateStudentBiodataUseCase {
  final StudentRepository repository;

  UpdateStudentBiodataUseCase(this.repository);

  Future<void> execute(Map<String, dynamic> data) {
    return repository.updateStudentBiodata(data);
  }
}

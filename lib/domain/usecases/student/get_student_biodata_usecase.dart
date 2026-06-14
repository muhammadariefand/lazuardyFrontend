import 'package:lazuadry_mobile_fe/domain/entities/student_biodata.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/student_repository.dart';

class GetStudentBiodataUseCase {
  final StudentRepository repository;

  GetStudentBiodataUseCase(this.repository);

  Future<StudentBiodata> execute() {
    return repository.getStudentBiodata();
  }
}

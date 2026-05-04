import 'package:lazuadry_mobile_fe/data/models/auth/register_student_request.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class StudentRegisterUsecase {
  final AuthRepository repository;
  StudentRegisterUsecase({required this.repository});

  Future<void> execute(RegisterStudentRequest request) {
    return repository.studentRegister(request);
  }
}
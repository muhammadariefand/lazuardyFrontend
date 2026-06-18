import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tutor_registration_repository.dart';

class RegisterTutorUseCase {
  final TutorRegistrationRepository repository;

  RegisterTutorUseCase(this.repository);

  Future<Map<String, dynamic>> execute(FormData formData) async {
    return await repository.tutorRegister(formData);
  }
}

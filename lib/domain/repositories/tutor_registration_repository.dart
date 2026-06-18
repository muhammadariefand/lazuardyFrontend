import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/domain/entities/subject_entity.dart';

abstract class TutorRegistrationRepository {
  Future<String> validateBankAccount(String bankCode, String accountNumber);
  Future<List<SubjectEntity>> getSubjectByClass(int classId);
  Future<Map<String, dynamic>> tutorRegister(FormData formData);
}

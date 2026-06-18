import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/datasources/tutor_registration_remote_ds.dart';
import 'package:lazuadry_mobile_fe/domain/entities/subject_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tutor_registration_repository.dart';

class TutorRegistrationRepositoryImpl implements TutorRegistrationRepository {
  final TutorRegistrationRemoteDataSource remoteDataSource;

  TutorRegistrationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> validateBankAccount(String bankCode, String accountNumber) async {
    return await remoteDataSource.validateBankAccount(bankCode, accountNumber);
  }

  @override
  Future<List<SubjectEntity>> getSubjectByClass(int classId) async {
    return await remoteDataSource.getSubjectByClass(classId);
  }

  @override
  Future<Map<String, dynamic>> tutorRegister(FormData formData) async {
    return await remoteDataSource.tutorRegister(formData);
  }
}

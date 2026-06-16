import 'package:lazuadry_mobile_fe/domain/entities/student_biodata.dart';

abstract class StudentRepository {
  Future<StudentBiodata> getStudentBiodata();
  Future<void> updateStudentBiodata(Map<String, dynamic> data);
  Future<void> updateProfilePhoto(List<int> fileBytes, String fileName);
}

import 'package:lazuadry_mobile_fe/domain/entities/student_biodata.dart';

abstract class StudentRepository {
  Future<StudentBiodata> getStudentBiodata();
}

import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/models/student_model.dart';

abstract class StudentRemoteDataSource {
  Future<StudentModel> getStudentBiodata();
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final Dio dio;

  StudentRemoteDataSourceImpl({required this.dio});

  @override
  Future<StudentModel> getStudentBiodata() async {
    final response = await dio.get('/student/biodata');

    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;

      final status = responseData['status']?.toString().toLowerCase();
      if (status == 'success' && responseData['data'] != null) {
        return StudentModel.fromJson(responseData['data'] as Map<String, dynamic>);
      }
    }

    throw Exception('Format respon biodata siswa tidak valid');
  }
}

import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/models/student_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';

abstract class StudentRemoteDataSource {
  Future<StudentModel> getStudentBiodata();
  Future<void> updateStudentBiodata(Map<String, dynamic> data);
  Future<void> updateProfilePhoto(List<int> fileBytes, String fileName);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final Dio dio;

  StudentRemoteDataSourceImpl({required this.dio});

  @override
  Future<StudentModel> getStudentBiodata() async {
    try {
      final response = await dio.get('/student/biodata');

      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        final status = responseData['status']?.toString().toLowerCase();
        if (status == 'success' && responseData['data'] != null) {
          return StudentModel.fromJson(responseData['data'] as Map<String, dynamic>);
        }
      }

      throw ServerException('Format respon biodata siswa tidak valid');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      String errorMessage = 'Terjadi kesalahan pada server';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] 
            ?? e.response?.data['error'] 
            ?? errorMessage;
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      throw ServerException(errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }

  @override
  Future<void> updateStudentBiodata(Map<String, dynamic> data) async {
    try {
      final response = await dio.put('/updateStudentBiodata', data: data);
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal memperbarui biodata');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map && data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final messages = errors.values
              .expand((v) => v is List ? v : [v])
              .map((e) => e.toString())
              .join('\n');
          throw ServerException(messages);
        }
        throw ServerException(data?['message'] ?? 'Data tidak valid');
      }
      String errorMessage = 'Gagal memperbarui biodata siswa';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      throw ServerException(errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }

  @override
  Future<void> updateProfilePhoto(List<int> fileBytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'profile_picture': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });

      final response = await dio.patch(
        '/updateProfilePhoto',
        data: formData,
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status'] != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal memperbarui foto profil');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map && data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final messages = errors.values
              .expand((v) => v is List ? v : [v])
              .map((e) => e.toString())
              .join('\n');
          throw ServerException(messages);
        }
        throw ServerException(data?['message'] ?? 'File foto tidak valid');
      }
      String errorMessage = 'Gagal memperbarui foto profil';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      throw ServerException(errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }
}

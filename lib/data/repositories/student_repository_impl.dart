import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/datasources/student_remote_ds.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/entities/student_biodata.dart';
import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<StudentBiodata> getStudentBiodata() async {
    try {
      return await remoteDataSource.getStudentBiodata();
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      if (statusCode == 400) {
        throw ServerException('Permintaan tidak valid.');
      }
      if (statusCode == 401) {
        throw ServerException('Sesi Anda telah berakhir. Silakan login kembali.');
      }
      if (statusCode != null && statusCode >= 500) {
        final message = data is Map ? data['message']?.toString() : null;
        throw ServerException(message ?? 'Gagal mengambil biodata siswa.');
      }

      final fallbackMessage = data is Map && data.containsKey('message')
          ? data['message'].toString()
          : (e.message ?? 'Gagal mengambil data biodata.');
      throw ServerException(fallbackMessage);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan tidak terduga saat mengambil biodata.');
    }
  }

  @override
  Future<void> updateStudentBiodata(Map<String, dynamic> data) async {
    try {
      return await remoteDataSource.updateStudentBiodata(data);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga saat memperbarui biodata.');
    }
  }

  @override
  Future<void> updateProfilePhoto(List<int> fileBytes, String fileName) async {
    try {
      return await remoteDataSource.updateProfilePhoto(fileBytes, fileName);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga saat memperbarui foto profil.');
    }
  }

  @override
  Future<PaginatedDataEntity<ReviewEntity>> getStudentReviews({
    int? tutorId,
    int? minRating,
    int? maxRating,
    int? page,
    int pagination = 10,
  }) async {
    try {
      return await remoteDataSource.getStudentReviews(
        tutorId: tutorId,
        minRating: minRating,
        maxRating: maxRating,
        page: page,
        pagination: pagination,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga saat mengambil daftar ulasan.');
    }
  }
}

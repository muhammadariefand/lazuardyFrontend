import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/models/student_model.dart';
import 'package:lazuadry_mobile_fe/data/models/review_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';

abstract class StudentRemoteDataSource {
  Future<StudentModel> getStudentBiodata();
  Future<void> updateStudentBiodata(Map<String, dynamic> data);
  Future<void> updateProfilePhoto(List<int> fileBytes, String fileName);
  Future<PaginatedDataEntity<ReviewEntity>> getStudentReviews({
    int? tutorId,
    int? minRating,
    int? maxRating,
    int? page,
    int pagination = 10,
  });
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

  @override
  Future<PaginatedDataEntity<ReviewEntity>> getStudentReviews({
    int? tutorId,
    int? minRating,
    int? maxRating,
    int? page,
    int pagination = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (tutorId != null) 'tutor_id': tutorId,
        if (minRating != null) 'min_rating': minRating,
        if (maxRating != null) 'max_rating': maxRating,
        if (page != null) 'page': page,
        'pagination': pagination,
      };

      final response = await dio.get(
        '/student/review',
        queryParameters: queryParams,
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status']?.toString().toLowerCase() == 'success' &&
          responseData['data'] != null) {
        final paginationData = responseData['data'] as Map<String, dynamic>;
        final itemsData = paginationData['data'] as List<dynamic>? ?? [];

        final items = itemsData
            .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return PaginatedDataEntity<ReviewEntity>(
          data: items,
          currentPage: paginationData['current_page'] as int? ?? 1,
          lastPage: paginationData['last_page'] as int? ?? 1,
          total: paginationData['total'] as int? ?? 0,
        );
      }
      throw ServerException('Format respon ulasan tidak valid');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException(e.response?.data['message'] ?? 'Forbidden');
      }
      String errorMessage = 'Terjadi kesalahan pada server';
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

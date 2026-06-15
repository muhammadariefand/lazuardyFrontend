import 'package:dio/dio.dart';
import '../models/tutor_model.dart';
import '../../domain/entities/server_exception.dart';

abstract class TutorProfileRemoteDataSource {
  Future<TutorModel> getTutorProfile();
}

class TutorProfileRemoteDataSourceImpl implements TutorProfileRemoteDataSource {
  final Dio dio;

  TutorProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<TutorModel> getTutorProfile() async {
    try {
      final response = await dio.get('/tutor/biodata');
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success') {
        return TutorModel.fromJson(responseData['data']);
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal memuat profil tutor');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Unauthenticated');
      }
      throw ServerException(e.message ?? 'Terjadi kesalahan pada server');
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }
}

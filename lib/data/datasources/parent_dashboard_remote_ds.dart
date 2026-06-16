import 'package:dio/dio.dart';
import '../models/parent_dashboard_model.dart';
import '../models/student_model.dart';
import '../../domain/entities/server_exception.dart';

abstract class ParentDashboardRemoteDataSource {
  Future<ParentDashboardModel> getDashboard();
  Future<StudentModel> getProfile();
}

class ParentDashboardRemoteDataSourceImpl implements ParentDashboardRemoteDataSource {
  final Dio dio;

  ParentDashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<ParentDashboardModel> getDashboard() async {
    try {
      final response = await dio.get('/parent/dashboard/homepage');
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == 'success') {
        return ParentDashboardModel.fromJson(responseData['data']);
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal memuat dashboard');
      }
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
  Future<StudentModel> getProfile() async {
    try {
      final response = await dio.get('/parent/dashboard/profile-page');
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == 'success') {
        return StudentModel.fromJson(responseData['data']);
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal memuat profil');
      }
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
}

import 'package:dio/dio.dart';
import '../models/package_model.dart';
import '../models/order_result_model.dart';
import '../../domain/entities/server_exception.dart';

abstract class PackageRemoteDataSource {
  Future<List<PackageModel>> getPackages();
  Future<PackageModel> getPackageDetail(int id);
  Future<OrderResultModel> orderPackages(List<Map<String, int>> packages);
}

class PackageRemoteDataSourceImpl implements PackageRemoteDataSource {
  final Dio dio;

  PackageRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PackageModel>> getPackages() async {
    try {
      final response = await dio.get('/getPackages');
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['success'] == 'success' || responseData['status'] == 'success') {
        final data = responseData['data'];
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          final listData = data['data'] as List<dynamic>;
          return listData.map((e) => PackageModel.fromJson(e as Map<String, dynamic>)).toList();
        } else if (data is List<dynamic>) {
          return data.map((e) => PackageModel.fromJson(e as Map<String, dynamic>)).toList();
        }
        return [];
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal memuat daftar paket');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      throw ServerException(e.message ?? 'Terjadi kesalahan pada server');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<PackageModel> getPackageDetail(int id) async {
    try {
      final response = await dio.get('/package/$id');
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        return PackageModel.fromJson(data);
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal memuat detail paket');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 404) {
        throw ServerException('Paket tidak ditemukan');
      }
      throw ServerException(e.message ?? 'Terjadi kesalahan pada server');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<OrderResultModel> orderPackages(List<Map<String, int>> packages) async {
    try {
      final response = await dio.post('/package/order', data: {
        'packages': packages,
      });
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        return OrderResultModel.fromJson(data);
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal membuat pesanan');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException('Hanya siswa yang dapat membeli paket');
      }
      // Coba extract message dari response body untuk semua error
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final msg = data['message'] as String?;
        if (msg != null && msg.isNotEmpty) {
          throw ServerException(msg);
        }
      }
      // Fallback berdasarkan status code
      final statusCode = e.response?.statusCode;
      if (statusCode == 400) {
        throw ServerException('Data pesanan tidak valid');
      }
      if (statusCode == 500) {
        throw ServerException('Gagal membuat pesanan, coba lagi nanti');
      }
      throw ServerException('Terjadi kesalahan pada server');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboardData({int page = 1});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<DashboardModel> getDashboardData({int page = 1}) async {
    try {
      final response = await dio.get(
        '/student/dashboard/homepage',
        queryParameters: {'page': page},
      );

      // Normalisasi: response.data bisa berupa Map, List, atau String.
      Map<String, dynamic>? responseData;

      if (response.data is Map<String, dynamic>) {
        responseData = response.data as Map<String, dynamic>;
      } else if (response.data is String) {
        // Jika server mengembalikan JSON string, coba decode
        try {
          final decoded = jsonDecode(response.data as String);
          if (decoded is Map<String, dynamic>) responseData = decoded;
        } catch (_) {
          // ignore JSON decode errors
        }
      } else if (response.data is List) {
        // Jika server mengembalikan List, coba cari elemen Map yang relevan
        final list = response.data as List;
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            // pilih item yang terlihat seperti payload (memiliki user_name atau notification)
            if (item.containsKey('user_name') || item.containsKey('notification')) {
              responseData = item;
              break;
            }
          }
        }
      }

      // Jika tidak berhasil dinormalisasi, fallback ke objek kosong agar UI tidak crash
      if (responseData == null) {
        // Log untuk debugging, tapi kembalikan DashboardModel default
        // (DashboardModel.fromJson({}) akan menghasilkan nilai default yang aman)
        return DashboardModel.fromJson({});
      }

      // Cek status dengan konversi ke String secara aman
      if (response.statusCode == 200 && responseData['status']?.toString() == 'success') {
        // Pastikan key 'data' ada dan merupakan Map sebelum di-parse ke Model
        if (responseData['data'] is Map<String, dynamic>) {
          return DashboardModel.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          // fallback: jika data tidak ada atau bukan Map, kembalikan default
          return DashboardModel.fromJson({});
        }
      } else {
        // Jika backend mengembalikan error status, lempar sebagai DioException agar caller bisa menanganinya
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: responseData['message']?.toString() ?? 'Gagal memuat data dashboard',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      // Menangkap error tak terduga (seperti error parsing di Model)
      throw Exception("Terjadi kesalahan saat memproses data: $e");
    }
  }
}
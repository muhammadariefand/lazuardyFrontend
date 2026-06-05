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
        queryParameters: {
          'page': page,
          'notification_paginate': 5, // Mengatur limit data notifikasi yang muncul di beranda (misal: 5)
          'tutor_paginate': 5,        // Mengatur limit data tutor yang muncul di beranda (misal: 5)
        },
      );

      // 1. Jika API mengirimkan List secara langsung
      if (response.data is List) {
        return DashboardModel.fromJson({'data': response.data});
      }

      // 2. Jika API mengirimkan Map (Object)
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        final status = responseData['status']?.toString().toLowerCase();
        if (status == 'success' || responseData['success'] == true || responseData['data'] != null) {
          final actualData = responseData['data'] ?? responseData;
          return DashboardModel.fromJson(actualData as Map<String, dynamic>);
        }
        
        return DashboardModel.fromJson(responseData);
      }

      throw Exception("Format respon tidak didukung: ${response.data.runtimeType}");
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final serverMessage = e.response?.data['message'] ?? e.response?.data['error'];
        if (serverMessage != null) {
          throw Exception(serverMessage);
        }
      }
      rethrow;
    } catch (e) {
      throw Exception("Gagal memproses data dashboard: $e");
    }
  }
}
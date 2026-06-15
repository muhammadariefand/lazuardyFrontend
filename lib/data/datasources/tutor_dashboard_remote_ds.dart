import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/models/tutor_dashboard_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';

abstract class TutorDashboardRemoteDataSource {
  Future<TutorDashboardModel> getHomepage({int notificationPage = 1});
}

class TutorDashboardRemoteDataSourceImpl implements TutorDashboardRemoteDataSource {
  final Dio dio;

  TutorDashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<TutorDashboardModel> getHomepage({int notificationPage = 1}) async {
    final response = await dio.get(
      '/tutor/dashboard/homepage',
      queryParameters: {'notification_page': notificationPage},
    );

    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;

      final status = responseData['status']?.toString().toLowerCase();
      if (status == 'success' && responseData['data'] != null) {
        return TutorDashboardModel.fromJson(responseData['data'] as Map<String, dynamic>);
      }
    }

    throw Exception('Format respon homepage tutor tidak valid');
  }
}

import '../entities/dashboard_entity.dart';

abstract class DashboardRepository {
  // Ingat, parameter token opsional ditaruh di parameter jika tidak ditangani otomatis oleh Interceptor Dio
  Future<DashboardEntity> getDashboardData({int page = 1}); 
}
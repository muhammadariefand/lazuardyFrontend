import 'package:lazuadry_mobile_fe/domain/entities/tutor_dashboard_entity.dart';

abstract class TutorDashboardRepository {
  Future<TutorDashboardEntity> getHomepage({int notificationPage = 1});
}

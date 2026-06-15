import '../entities/parent_dashboard_entity.dart';

abstract class ParentDashboardRepository {
  Future<ParentDashboardEntity> getDashboard();
}

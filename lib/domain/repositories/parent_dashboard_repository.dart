import '../entities/parent_dashboard_entity.dart';
import '../entities/student_biodata.dart';

abstract class ParentDashboardRepository {
  Future<ParentDashboardEntity> getDashboard();
  Future<StudentBiodata> getProfile();
}

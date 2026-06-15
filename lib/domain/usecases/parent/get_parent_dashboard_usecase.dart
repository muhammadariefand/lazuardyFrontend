import '../../entities/parent_dashboard_entity.dart';
import '../../repositories/parent_dashboard_repository.dart';

class GetParentDashboardUseCase {
  final ParentDashboardRepository repository;

  GetParentDashboardUseCase(this.repository);

  Future<ParentDashboardEntity> execute() {
    return repository.getDashboard();
  }
}

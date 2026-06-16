import '../entities/student_biodata.dart';
import '../repositories/parent_dashboard_repository.dart';

class GetParentProfileUseCase {
  final ParentDashboardRepository repository;

  GetParentProfileUseCase(this.repository);

  Future<StudentBiodata> execute() {
    return repository.getProfile();
  }
}

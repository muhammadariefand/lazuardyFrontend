import 'package:lazuadry_mobile_fe/domain/entities/tutor_dashboard_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tutor_dashboard_repository.dart';

class GetTutorDashboardUseCase {
  final TutorDashboardRepository repository;

  GetTutorDashboardUseCase(this.repository);

  Future<TutorDashboardEntity> execute({int notificationPage = 1}) {
    return repository.getHomepage(notificationPage: notificationPage);
  }
}

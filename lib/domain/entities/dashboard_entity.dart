import 'notification_entity.dart';
import 'tutor_entity.dart';
import 'paginated_data_entity.dart';

class DashboardEntity {
  final String userName;
  final int warning;
  final DateTime? sanction;
  final int session;
  final PaginatedDataEntity<NotificationEntity> notifications;
  final PaginatedDataEntity<TutorEntity> tutorRecommendations;

  DashboardEntity({
    required this.userName,
    required this.warning,
    this.sanction,
    required this.session,
    required this.notifications,
    required this.tutorRecommendations,
  });
}
import 'notification_entity.dart';
import 'schedule_entity.dart';
import 'paginated_data_entity.dart';

class ParentDashboardEntity {
  final String userName;
  final int warning;
  final DateTime? sanction;
  final int session;
  final PaginatedDataEntity<NotificationEntity> notifications;
  final PaginatedDataEntity<ScheduleEntity> schedulesHistory;

  ParentDashboardEntity({
    required this.userName,
    required this.warning,
    this.sanction,
    required this.session,
    required this.notifications,
    required this.schedulesHistory,
  });
}

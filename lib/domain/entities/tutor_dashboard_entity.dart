import 'package:lazuadry_mobile_fe/domain/entities/notification_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_entity.dart';

class TutorDashboardEntity {
  final TutorEntity tutor;
  final double salary;
  final double salaryStats;
  final int schedulesTotal;
  final int studentTotal;
  final PaginatedDataEntity<NotificationEntity> notifications;
  final int warning;

  TutorDashboardEntity({
    required this.tutor,
    required this.salary,
    required this.salaryStats,
    required this.schedulesTotal,
    required this.studentTotal,
    required this.notifications,
    required this.warning,
  });
}

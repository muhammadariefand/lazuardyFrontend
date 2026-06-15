import '../../domain/entities/parent_dashboard_entity.dart';
import 'notification_model.dart';
import 'schedule_model.dart';
import 'paginated_data_model.dart';

class ParentDashboardModel extends ParentDashboardEntity {
  ParentDashboardModel({
    required super.userName,
    required super.warning,
    super.sanction,
    required super.session,
    required super.notifications,
    required super.schedulesHistory,
  });

  factory ParentDashboardModel.fromJson(Map<String, dynamic> json) {
    return ParentDashboardModel(
      userName: json['me']['email']?.toString() ?? 'Orang Tua',
      warning: json['warning'] ?? 0,
      sanction: json['sanction'] != null ? DateTime.tryParse(json['sanction']) : null,
      session: int.tryParse(json['session']?.toString() ?? '0') ?? 0,
      notifications: PaginatedDataModel<NotificationModel>.fromJson(
        json['notification'],
        (json['notification']['data'] as List).map((data) => NotificationModel.fromJson(data as Map<String, dynamic>)).toList(),
      ),
      schedulesHistory: PaginatedDataModel<ScheduleModel>.fromJson(
        json['schedules_history'],
        (json['schedules_history']['data'] as List).map((data) => ScheduleModel.fromJson(data as Map<String, dynamic>)).toList(),
      ),
    );
  }
}

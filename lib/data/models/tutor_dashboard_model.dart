import 'package:lazuadry_mobile_fe/data/models/notification_model.dart';
import 'package:lazuadry_mobile_fe/data/models/paginated_data_model.dart';
import 'package:lazuadry_mobile_fe/data/models/tutor_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_dashboard_entity.dart';

class TutorDashboardModel extends TutorDashboardEntity {
  TutorDashboardModel({
    required super.tutor,
    required super.salary,
    required super.salaryStats,
    required super.schedulesTotal,
    required super.studentTotal,
    required super.notifications,
    required super.warning,
  });

  factory TutorDashboardModel.fromJson(Map<String, dynamic> json) {
    return TutorDashboardModel(
      tutor: TutorModel.fromJson(json['tutor'] ?? {}),
      salary: double.tryParse(json['salary']?.toString() ?? '0') ?? 0.0,
      salaryStats: double.tryParse(json['salary_stats']?.toString() ?? '0') ?? 0.0,
      schedulesTotal: json['schedules_total'] is int
          ? json['schedules_total']
          : int.tryParse(json['schedules_total']?.toString() ?? '0') ?? 0,
      studentTotal: json['student_total'] is int
          ? json['student_total']
          : int.tryParse(json['student_total']?.toString() ?? '0') ?? 0,
      notifications: PaginatedDataModel<NotificationModel>.fromJson(
        json['notification_data'] ?? {},
        (json['notification_data']?['data'] as List<dynamic>?)
                ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      ),
      warning: json['warning'] is int
          ? json['warning']
          : int.tryParse(json['warning']?.toString() ?? '0') ?? 0,
    );
  }
}

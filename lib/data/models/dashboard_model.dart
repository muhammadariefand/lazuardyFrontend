import '../../domain/entities/dashboard_entity.dart';
import 'notification_model.dart';
import 'tutor_model.dart';
import 'paginated_data_model.dart';

class DashboardModel extends DashboardEntity {
  DashboardModel({
    required super.userName,
    required super.warning,
    super.sanction,
    required super.session,
    required super.notifications,
    required super.tutorRecommendations,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    // Parsing tanggal sanction secara aman
    DateTime? parsedSanction;
    if (json['sanction'] != null) {
      parsedSanction = DateTime.tryParse(json['sanction'].toString());
    }

    // Parsing pagination Notifikasi
    final notifJson = json['notification'] as Map<String, dynamic>? ?? {};
    final notifRawList = notifJson['data'] as List<dynamic>? ?? [];
    final notifList = notifRawList
        .map((x) => NotificationModel.fromJson(x as Map<String, dynamic>))
        .toList();
    final notificationsModel = PaginatedDataModel.fromJson(notifJson, notifList);

    // Parsing pagination Rekomendasi Tutor
    final tutorJson = json['tutor_recomendation'] as Map<String, dynamic>? ?? {};
    final tutorRawList = tutorJson['data'] as List<dynamic>? ?? [];
    final tutorList = tutorRawList
        .map((x) => TutorModel.fromJson(x as Map<String, dynamic>))
        .toList();
    final tutorRecommendationsModel = PaginatedDataModel.fromJson(tutorJson, tutorList);

    return DashboardModel(
      userName: json['user_name']?.toString() ?? '',
      warning: int.tryParse(json['warning'].toString()) ?? 0,
      sanction: parsedSanction,
      session: int.tryParse(json['session'].toString()) ?? 0,
      notifications: notificationsModel,
      tutorRecommendations: tutorRecommendationsModel,
    );
  }
}
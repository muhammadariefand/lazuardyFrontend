import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    super.orderId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Mengekstrak order_id dari dalam nested object "data"
    final nestedData = json['data'] as Map<String, dynamic>?;

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      orderId: nestedData?['order_id']?.toString(),
    );
  }
}
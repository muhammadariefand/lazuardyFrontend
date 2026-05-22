class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final String? orderId; // Kita ekstrak langsung dari object "data" di JSON

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.orderId,
  });
}
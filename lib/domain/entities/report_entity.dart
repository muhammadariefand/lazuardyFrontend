class ReportEntity {
  final int id;
  final int scheduleId;
  final int tutorId;
  final String tutorName;
  final int studentId;
  final String studentName;
  final String topic;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportEntity({
    required this.id,
    required this.scheduleId,
    required this.tutorId,
    required this.tutorName,
    required this.studentId,
    required this.studentName,
    required this.topic,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
}

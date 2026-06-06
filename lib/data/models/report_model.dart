import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  ReportModel({
    required super.id,
    required super.scheduleId,
    required super.tutorId,
    required super.tutorName,
    required super.studentId,
    required super.studentName,
    required super.topic,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
      if (value is DateTime) return value;
      return DateTime.tryParse(value.toString()) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }

    return ReportModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      scheduleId: int.tryParse(json['scheduleId']?.toString() ?? '') ?? 0,
      tutorId: int.tryParse(json['tutorId']?.toString() ?? '') ?? 0,
      tutorName: json['tutorName']?.toString() ?? '',
      studentId: int.tryParse(json['studentId']?.toString() ?? '') ?? 0,
      studentName: json['studentName']?.toString() ?? '',
      topic: json['topic']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseDateTime(json['updatedAt']),
    );
  }
}

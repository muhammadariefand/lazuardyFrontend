import '../../domain/entities/schedule_entity.dart';

class ScheduleModel extends ScheduleEntity {
  ScheduleModel({
    required super.id,
    required super.tutorId,
    required super.studentId,
    required super.subjectId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.learningMethod,
    super.meetingLink,
    required super.address,
    required super.tutorName,
    required super.subjectName,
    required super.studentName,
    super.tutorTelephoneNumber,
    super.studentTelephoneNumber,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
      if (value is DateTime) return value;
      return DateTime.tryParse(value.toString()) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }

    return ScheduleModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      tutorId: int.tryParse(json['tutorId']?.toString() ?? '') ?? 0,
      studentId: int.tryParse(json['studentId']?.toString() ?? '') ?? 0,
      subjectId: int.tryParse(json['subjectId']?.toString() ?? '') ?? 0,
      date: parseDateTime(json['date']),
      startTime: parseDateTime(json['startTime']),
      endTime: parseDateTime(json['endTime']),
      status: json['status']?.toString() ?? '',
      learningMethod: json['learningMethod']?.toString() ?? '',
      meetingLink: json['meetingLink']?.toString(),
      address: json['address']?.toString() ?? '',
      tutorName: json['tutorName']?.toString() ?? '',
      subjectName: json['subjectName']?.toString() ?? '',
      studentName: json['studentName']?.toString() ?? '',
      tutorTelephoneNumber: json['tutorTelephoneNumber']?.toString(),
      studentTelephoneNumber: json['studentTelephoneNumber']?.toString(),
    );
  }
}

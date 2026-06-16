class ScheduleEntity {
  final int id;
  final int tutorId;
  final int studentId;
  final int subjectId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String learningMethod;
  final String? meetingLink;
  final String address;
  final String tutorName;
  final String subjectName;
  final String studentName;
  final String? tutorTelephoneNumber;
  final String? studentTelephoneNumber;

  ScheduleEntity({
    required this.id,
    required this.tutorId,
    required this.studentId,
    required this.subjectId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.learningMethod,
    this.meetingLink,
    required this.address,
    required this.tutorName,
    required this.subjectName,
    required this.studentName,
    this.tutorTelephoneNumber,
    this.studentTelephoneNumber,
  });
}

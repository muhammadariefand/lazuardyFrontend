class ReviewEntity {
  final int id;
  final int studentId;
  final int tutorId;
  final double rate;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Optional fields for UI
  final String tutorName;
  final String subjectName;

  ReviewEntity({
    required this.id,
    required this.studentId,
    required this.tutorId,
    required this.rate,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.tutorName = '',
    this.subjectName = '',
  });
}

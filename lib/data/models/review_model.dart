import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required super.id,
    required super.studentId,
    required super.tutorId,
    required super.rate,
    required super.comment,
    required super.createdAt,
    required super.updatedAt,
    super.tutorName,
    super.subjectName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int,
      studentId: json['studentId'] as int,
      tutorId: json['tutorId'] as int,
      rate: (json['rate'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
      tutorName: json['tutor_name'] as String? ?? '', // Fallback for UI if API adds it later
      subjectName: json['subject_name'] as String? ?? '',
    );
  }
}

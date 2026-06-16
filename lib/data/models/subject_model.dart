import '../../domain/entities/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  SubjectModel({
    required super.id,
    required super.name,
    super.level,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      level: json['level']?.toString(),
    );
  }
}

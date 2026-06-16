import '../../domain/entities/tutor_availability_entity.dart';

class TutorAvailabilityModel extends TutorAvailabilityEntity {
  TutorAvailabilityModel({
    required super.id,
    required super.tutorId,
    required super.day,
    required super.time,
  });

  factory TutorAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return TutorAvailabilityModel(
      id: int.parse(json['id'].toString()),
      tutorId: int.parse(json['tutorId']?.toString() ?? json['tutor_id']?.toString() ?? '0'),
      day: json['day'].toString(),
      time: json['time'].toString(),
    );
  }
}

import '../../domain/entities/region_entity.dart';

class RegionModel extends RegionEntity {
  RegionModel({required super.id, required super.name});

  factory RegionModel.fromJson(Map<String, dynamic> json) {
  return RegionModel(
    id: json['id'].toString(),
    name: json['name']?.toString() ?? '',
    );
  }
}
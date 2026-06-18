import '../../domain/entities/package_entity.dart';
import '../../core/constants/app_constants.dart';

class PackageModel extends PackageEntity {
  PackageModel({
    required super.id,
    required super.name,
    required super.session,
    required super.price,
    super.discount,
    required super.description,
    super.imagePath,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      session: json['session'] as int? ?? 0,
      price: json['price'] is int ? json['price'] : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      discount: json['discount'] != null ? double.tryParse(json['discount'].toString()) : null,
      description: json['description'] ?? '',
      imagePath: AppApiConstants.getImageUrl(json['imagePath']?.toString()),
    );
  }
}

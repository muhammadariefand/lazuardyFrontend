class PackageEntity {
  final int id;
  final String name;
  final int session;
  final int price;
  final double? discount;
  final String description;
  final String? imagePath;

  PackageEntity({
    required this.id,
    required this.name,
    required this.session,
    required this.price,
    this.discount,
    required this.description,
    this.imagePath,
  });
}

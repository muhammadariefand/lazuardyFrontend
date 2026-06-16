import '../../../domain/entities/package_entity.dart';

abstract class PackageState {}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageLoaded extends PackageState {
  final List<PackageEntity> packages;

  PackageLoaded(this.packages);
}

class PackageError extends PackageState {
  final String message;

  PackageError(this.message);
}

// ── Detail Paket States ──────────────────────────────────────────

class PackageDetailLoaded extends PackageState {
  final PackageEntity package;

  PackageDetailLoaded(this.package);
}

// ── Order States ─────────────────────────────────────────────────

class PackageOrderLoading extends PackageState {}

class PackageOrderSuccess extends PackageState {
  final int orderId;
  final String checkoutUrl;

  PackageOrderSuccess({
    required this.orderId,
    required this.checkoutUrl,
  });
}

class PackageOrderError extends PackageState {
  final String message;

  PackageOrderError(this.message);
}

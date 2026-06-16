import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/student/get_packages_usecase.dart';
import '../../../domain/usecases/student/get_package_detail_usecase.dart';
import '../../../domain/usecases/student/order_packages_usecase.dart';
import 'package_state.dart';

class PackageCubit extends Cubit<PackageState> {
  final GetPackagesUseCase getPackagesUseCase;
  final GetPackageDetailUseCase getPackageDetailUseCase;
  final OrderPackagesUseCase orderPackagesUseCase;

  PackageCubit({
    required this.getPackagesUseCase,
    required this.getPackageDetailUseCase,
    required this.orderPackagesUseCase,
  }) : super(PackageInitial());

  Future<void> fetchPackages() async {
    emit(PackageLoading());
    try {
      final packages = await getPackagesUseCase.execute();
      emit(PackageLoaded(packages));
    } catch (e) {
      emit(PackageError(e.toString()));
    }
  }

  Future<void> fetchPackageDetail(int id) async {
    emit(PackageLoading());
    try {
      final package = await getPackageDetailUseCase.execute(id);
      emit(PackageDetailLoaded(package));
    } catch (e) {
      emit(PackageError(e.toString()));
    }
  }

  /// Order paket — packages berupa list [{'id': x, 'quantity': y}]
  Future<void> orderPackages(List<Map<String, int>> packages) async {
    emit(PackageOrderLoading());
    try {
      final result = await orderPackagesUseCase.execute(packages);
      emit(PackageOrderSuccess(
        orderId: result.orderId,
        checkoutUrl: result.checkoutUrl,
      ));
    } catch (e) {
      emit(PackageOrderError(e.toString()));
    }
  }
}

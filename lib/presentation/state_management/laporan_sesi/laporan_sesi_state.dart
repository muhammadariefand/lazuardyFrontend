// lib/presentation/state_management/laporan_sesi/laporan_sesi_state.dart

abstract class LaporanSesiState {}

class LaporanSesiInitial extends LaporanSesiState {}

class LaporanSesiLoading extends LaporanSesiState {}

class LaporanSesiSuccess extends LaporanSesiState {
  final String message;

  LaporanSesiSuccess(this.message);
}

class LaporanSesiError extends LaporanSesiState {
  final String message;

  LaporanSesiError(this.message);
}

import 'package:equatable/equatable.dart';
import '../../../domain/entities/schedule_entity.dart';

abstract class PembatalanSesiState extends Equatable {
  const PembatalanSesiState();
  @override
  List<Object?> get props => [];
}

/// State awal
class PembatalanSesiInitial extends PembatalanSesiState {
  const PembatalanSesiInitial();
}

/// Loading saat mengambil detail sesi
class PembatalanSesiDetailLoading extends PembatalanSesiState {
  const PembatalanSesiDetailLoading();
}

/// Detail sesi berhasil dimuat
class PembatalanSesiDetailLoaded extends PembatalanSesiState {
  final ScheduleEntity schedule;
  const PembatalanSesiDetailLoaded(this.schedule);
  @override
  List<Object?> get props => [schedule];
}

/// Loading saat proses pembatalan
class PembatalanSesiCancelLoading extends PembatalanSesiState {
  const PembatalanSesiCancelLoading();
}

/// Pembatalan berhasil
class PembatalanSesiSuccess extends PembatalanSesiState {
  const PembatalanSesiSuccess();
}

/// Error (ambil detail atau batalkan)
class PembatalanSesiError extends PembatalanSesiState {
  final String message;
  const PembatalanSesiError(this.message);
  @override
  List<Object?> get props => [message];
}

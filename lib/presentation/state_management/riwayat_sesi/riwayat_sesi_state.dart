import 'package:equatable/equatable.dart';
import '../../../domain/entities/schedule_entity.dart';

abstract class RiwayatSesiState extends Equatable {
  const RiwayatSesiState();

  @override
  List<Object?> get props => [];
}

/// State awal sebelum ada aksi
class RiwayatSesiInitial extends RiwayatSesiState {
  const RiwayatSesiInitial();
}

/// Loading umum (daftar sesi, detail)
class RiwayatSesiLoading extends RiwayatSesiState {
  const RiwayatSesiLoading();
}

/// Daftar riwayat sesi berhasil dimuat
class RiwayatSesiListLoaded extends RiwayatSesiState {
  final List<ScheduleEntity> schedules;

  const RiwayatSesiListLoaded(this.schedules);

  @override
  List<Object?> get props => [schedules];
}

/// Detail satu sesi berhasil dimuat
class ScheduleDetailLoaded extends RiwayatSesiState {
  final ScheduleEntity schedule;

  const ScheduleDetailLoaded(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

/// Loading khusus untuk aksi konfirmasi selesai
class MarkCompleteLoading extends RiwayatSesiState {
  const MarkCompleteLoading();
}

/// Konfirmasi selesai berhasil
class MarkCompleteSuccess extends RiwayatSesiState {
  const MarkCompleteSuccess();
}

/// Loading khusus untuk submit review
class SubmitReviewLoading extends RiwayatSesiState {
  const SubmitReviewLoading();
}

/// Submit review berhasil
class SubmitReviewSuccess extends RiwayatSesiState {
  const SubmitReviewSuccess();
}

/// Error (semua operasi)
class RiwayatSesiError extends RiwayatSesiState {
  final String message;

  const RiwayatSesiError(this.message);

  @override
  List<Object?> get props => [message];
}

// lib/presentation/state_management/laporan_sesi/laporan_sesi_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/tutor/create_presence_usecase.dart';
import 'laporan_sesi_state.dart';

class LaporanSesiCubit extends Cubit<LaporanSesiState> {
  final CreatePresenceUseCase createPresenceUseCase;

  LaporanSesiCubit({required this.createPresenceUseCase})
      : super(LaporanSesiInitial());

  Future<void> kirimLaporan({
    required int scheduleId,
    required String topic,
    required String notes,
  }) async {
    if (isClosed) return;
    emit(LaporanSesiLoading());

    try {
      await createPresenceUseCase.execute(
        scheduleId: scheduleId,
        topic: topic,
        notes: notes,
      );

      if (!isClosed) {
        emit(LaporanSesiSuccess('Laporan berhasil dikirim!'));
      }
    } catch (e) {
      if (!isClosed) {
        emit(LaporanSesiError(e.toString()));
      }
    }
  }
}

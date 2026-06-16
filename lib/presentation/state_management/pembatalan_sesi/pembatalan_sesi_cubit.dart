import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/server_exception.dart';
import '../../../domain/usecases/student/get_schedule_by_id_usecase.dart';
import '../../../domain/usecases/tutor/cancel_schedule_usecase.dart';
import 'pembatalan_sesi_state.dart';

class PembatalanSesiCubit extends Cubit<PembatalanSesiState> {
  final GetScheduleByIdUseCase getScheduleByIdUseCase;
  final CancelScheduleUseCase cancelScheduleUseCase;

  PembatalanSesiCubit({
    required this.getScheduleByIdUseCase,
    required this.cancelScheduleUseCase,
  }) : super(const PembatalanSesiInitial());

  /// Ambil detail sesi (GET /schedule/getById)
  Future<void> fetchScheduleDetail(int scheduleId) async {
    emit(const PembatalanSesiDetailLoading());
    try {
      final schedule = await getScheduleByIdUseCase.execute(scheduleId);
      emit(PembatalanSesiDetailLoaded(schedule));
    } on ServerException catch (e) {
      emit(PembatalanSesiError(e.message));
    } catch (_) {
      emit(const PembatalanSesiError('Terjadi kesalahan yang tidak terduga'));
    }
  }

  /// Batalkan sesi (POST /schedule/cancel)
  Future<void> cancelSchedule({
    required int scheduleId,
    required String reason,
  }) async {
    emit(const PembatalanSesiCancelLoading());
    try {
      await cancelScheduleUseCase.execute(
        scheduleId: scheduleId,
        reason: reason,
      );
      emit(const PembatalanSesiSuccess());
    } on ServerException catch (e) {
      emit(PembatalanSesiError(e.message));
    } catch (_) {
      emit(const PembatalanSesiError('Terjadi kesalahan yang tidak terduga'));
    }
  }
}

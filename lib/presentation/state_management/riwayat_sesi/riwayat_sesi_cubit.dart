import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/server_exception.dart';
import '../../../domain/usecases/get_schedules_usecase.dart';
import '../../../domain/usecases/student/get_schedule_by_id_usecase.dart';
import '../../../domain/usecases/student/mark_schedule_complete_usecase.dart';
import '../../../domain/usecases/student/submit_review_usecase.dart';
import 'riwayat_sesi_state.dart';

class RiwayatSesiCubit extends Cubit<RiwayatSesiState> {
  final GetSchedulesUseCase getSchedulesUseCase;
  final GetScheduleByIdUseCase getScheduleByIdUseCase;
  final MarkScheduleCompleteUseCase markScheduleCompleteUseCase;
  final SubmitReviewUseCase submitReviewUseCase;

  RiwayatSesiCubit({
    required this.getSchedulesUseCase,
    required this.getScheduleByIdUseCase,
    required this.markScheduleCompleteUseCase,
    required this.submitReviewUseCase,
  }) : super(const RiwayatSesiInitial());

  /// Ambil daftar semua riwayat sesi siswa (tanpa filter status)
  Future<void> fetchRiwayatSesi() async {
    emit(const RiwayatSesiLoading());
    try {
      final result = await getSchedulesUseCase.execute(status: '', date: '');
      emit(RiwayatSesiListLoaded(result.data));
    } on ServerException catch (e) {
      emit(RiwayatSesiError(e.message));
    } catch (e) {
      emit(RiwayatSesiError('Terjadi kesalahan yang tidak terduga'));
    }
  }

  /// Ambil detail satu sesi berdasarkan ID
  Future<void> fetchScheduleById(int scheduleId) async {
    emit(const RiwayatSesiLoading());
    try {
      final schedule = await getScheduleByIdUseCase.execute(scheduleId);
      emit(ScheduleDetailLoaded(schedule));
    } on ServerException catch (e) {
      emit(RiwayatSesiError(e.message));
    } catch (e) {
      emit(RiwayatSesiError('Terjadi kesalahan yang tidak terduga'));
    }
  }

  /// Tandai sesi sebagai selesai (PATCH /student/schedule/mark-as-complete)
  Future<void> markComplete(int scheduleId) async {
    emit(const MarkCompleteLoading());
    try {
      await markScheduleCompleteUseCase.execute(scheduleId);
      emit(const MarkCompleteSuccess());
    } on ServerException catch (e) {
      emit(RiwayatSesiError(e.message));
    } catch (e) {
      emit(RiwayatSesiError('Terjadi kesalahan yang tidak terduga'));
    }
  }

  /// Kirim rating tutor (POST /student/review/create)
  Future<void> submitReview({
    required int tutorId,
    required double rate,
    required String comment,
  }) async {
    emit(const SubmitReviewLoading());
    try {
      await submitReviewUseCase.execute(
        tutorId: tutorId,
        rate: rate,
        comment: comment,
      );
      emit(const SubmitReviewSuccess());
    } on ServerException catch (e) {
      emit(RiwayatSesiError(e.message));
    } catch (e) {
      emit(RiwayatSesiError('Terjadi kesalahan yang tidak terduga'));
    }
  }
}

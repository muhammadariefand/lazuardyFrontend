import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/server_exception.dart';
import '../../../domain/usecases/get_reports_usecase.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final GetReportsUseCase getReportsUseCase;

  ReportCubit({required this.getReportsUseCase}) : super(ReportInitial());

  Future<void> loadReports({required int page}) async {
    emit(ReportLoading());
    try {
      final data = await getReportsUseCase.execute(page: page);
      emit(ReportLoaded(data));
    } on ServerException catch (e) {
      emit(ReportError(e.message));
    } catch (e) {
      emit(ReportError('Terjadi kesalahan saat memuat laporan.'));
    }
  }
}

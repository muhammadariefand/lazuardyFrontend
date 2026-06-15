import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_tutor_dashboard_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_dashboard/tutor_dashboard_state.dart';

class TutorDashboardCubit extends Cubit<TutorDashboardState> {
  final GetTutorDashboardUseCase getTutorDashboardUseCase;

  TutorDashboardCubit({required this.getTutorDashboardUseCase}) : super(TutorDashboardInitial());

  Future<void> loadDashboard({int notificationPage = 1}) async {
    emit(TutorDashboardLoading());
    try {
      final dashboardData = await getTutorDashboardUseCase.execute(notificationPage: notificationPage);
      emit(TutorDashboardLoaded(dashboardData));
    } on ServerException catch (e) {
      emit(TutorDashboardError(e.message));
    } catch (e) {
      emit(TutorDashboardError('Terjadi kesalahan saat memuat dashboard.'));
    }
  }
}

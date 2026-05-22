import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_dashboard_data_usecase.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardDataUseCase getDashboardDataUseCase;

  DashboardCubit({required this.getDashboardDataUseCase}) : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      final data = await getDashboardDataUseCase.execute();
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
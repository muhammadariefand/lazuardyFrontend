import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/server_exception.dart';
import '../../../domain/usecases/parent/get_parent_dashboard_usecase.dart';
import 'parent_dashboard_state.dart';

class ParentDashboardCubit extends Cubit<ParentDashboardState> {
  final GetParentDashboardUseCase getDashboardUseCase;

  ParentDashboardCubit({required this.getDashboardUseCase}) : super(ParentDashboardInitial());

  Future<void> fetchDashboard() async {
    emit(ParentDashboardLoading());
    try {
      final dashboard = await getDashboardUseCase.execute();
      emit(ParentDashboardLoaded(dashboard));
    } on ServerException catch (e) {
      emit(ParentDashboardError(e.message));
    } catch (e) {
      emit(ParentDashboardError('Terjadi kesalahan yang tidak terduga'));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_schedules_usecase.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final GetSchedulesUseCase getSchedulesUseCase;

  ScheduleCubit({required this.getSchedulesUseCase}) : super(ScheduleInitial());

  Future<void> loadSchedules({required String status, required String date}) async {
    emit(ScheduleLoading());
    try {
      final data = await getSchedulesUseCase.execute(status: status, date: date);
      emit(ScheduleLoaded(data));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}

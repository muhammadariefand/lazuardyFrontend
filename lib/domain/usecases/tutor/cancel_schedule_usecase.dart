import '../../repositories/schedule_repository.dart';

class CancelScheduleUseCase {
  final ScheduleRepository repository;

  CancelScheduleUseCase(this.repository);

  Future<void> execute({
    required int scheduleId,
    required String reason,
  }) {
    return repository.cancelSchedule(
      scheduleId: scheduleId,
      reason: reason,
    );
  }
}

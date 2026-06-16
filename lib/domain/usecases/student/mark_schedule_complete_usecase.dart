import '../../repositories/schedule_repository.dart';

class MarkScheduleCompleteUseCase {
  final ScheduleRepository repository;

  MarkScheduleCompleteUseCase(this.repository);

  Future<void> execute(int scheduleId) {
    return repository.markScheduleComplete(scheduleId);
  }
}

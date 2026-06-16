import '../../repositories/schedule_repository.dart';

class CreatePresenceUseCase {
  final ScheduleRepository repository;

  CreatePresenceUseCase(this.repository);

  Future<void> execute({
    required int scheduleId,
    required String topic,
    required String notes,
  }) {
    return repository.createPresence(
      scheduleId: scheduleId,
      topic: topic,
      notes: notes,
    );
  }
}

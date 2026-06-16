import '../../repositories/schedule_repository.dart';
import '../../entities/schedule_entity.dart';

class GetScheduleByIdUseCase {
  final ScheduleRepository repository;

  GetScheduleByIdUseCase(this.repository);

  Future<ScheduleEntity> execute(int scheduleId) {
    return repository.getScheduleById(scheduleId);
  }
}

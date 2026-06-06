import '../entities/schedule_entity.dart';
import '../entities/paginated_data_entity.dart';
import '../repositories/schedule_repository.dart';

class GetSchedulesUseCase {
  final ScheduleRepository repository;

  GetSchedulesUseCase(this.repository);

  Future<PaginatedDataEntity<ScheduleEntity>> execute({
    required String status,
    required String date,
    int page = 1,
  }) {
    return repository.getSchedules(status: status, date: date, page: page);
  }
}

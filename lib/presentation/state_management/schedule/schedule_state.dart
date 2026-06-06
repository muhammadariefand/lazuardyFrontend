import '../../../domain/entities/paginated_data_entity.dart';
import '../../../domain/entities/schedule_entity.dart';

abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final PaginatedDataEntity<ScheduleEntity> data;
  ScheduleLoaded(this.data);
}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError(this.message);
}

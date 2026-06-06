import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/report_entity.dart';


abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final PaginatedDataEntity<ReportEntity> data;

  ReportLoaded(this.data);
}

class ReportError extends ReportState {
  final String message;

  ReportError(this.message);
}

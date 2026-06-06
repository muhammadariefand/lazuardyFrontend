import '../entities/report_entity.dart';
import '../entities/paginated_data_entity.dart';

abstract class ReportRepository {
  Future<PaginatedDataEntity<ReportEntity>> getReports({
    required int page,
  });
}

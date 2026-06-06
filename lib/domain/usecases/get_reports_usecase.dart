import '../entities/report_entity.dart';
import '../entities/paginated_data_entity.dart';
import '../repositories/report_repository.dart';

class GetReportsUseCase {
  final ReportRepository repository;

  GetReportsUseCase(this.repository);

  Future<PaginatedDataEntity<ReportEntity>> execute({required int page}) {
    return repository.getReports(page: page);
  }
}

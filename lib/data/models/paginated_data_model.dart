import '../../domain/entities/paginated_data_entity.dart';

class PaginatedDataModel<T> extends PaginatedDataEntity<T> {
  PaginatedDataModel({
    required super.data,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory PaginatedDataModel.fromJson(Map<String, dynamic> json, List<T> dataList) {
    return PaginatedDataModel<T>(
      data: dataList,
      currentPage: int.tryParse(json['current_page'].toString()) ?? 1,
      lastPage: int.tryParse(json['last_page'].toString()) ?? 1,
      total: int.tryParse(json['total'].toString()) ?? 0,
    );
  }
}
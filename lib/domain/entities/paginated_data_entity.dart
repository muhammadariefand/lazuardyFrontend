class PaginatedDataEntity<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;

  PaginatedDataEntity({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  // Fungsi pembantu untuk mengecek apakah masih ada halaman selanjutnya
  bool get hasNextPage => currentPage < lastPage;
}
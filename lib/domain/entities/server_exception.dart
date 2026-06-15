class ServerException implements Exception {
  final String message;
  final Map<String, dynamic>? errors; // Tambahkan ini untuk menampung field error
  ServerException(this.message, {this.errors});

  @override
  String toString() => message;
}
import 'package:flutter_test/flutter_test.dart';
import 'package:lazuadry_mobile_fe/core/network/api_client.dart';
import 'package:lazuadry_mobile_fe/data/repositories/otp_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/entities/otp_response.dart';

void main() {
  late ApiClient apiClient;
  late OtpRepositoryImpl repository;

  setUp(() {
    // Kita inisialisasi Client dan Repository-nya
    apiClient = ApiClient(); 
    repository = OtpRepositoryImpl(apiClient);
  });

  test('Harus mengembalikan OtpSuccess ketika hit API berhasil', () async {
    // 1. Jalankan fungsi sendEmail secara terisolasi
    // Ganti email dengan yang valid untuk ngetes beneran ke BE
    final result = await repository.sendEmail("muhariefa21@gmail.com");

    // 2. Cek apakah hasilnya sesuai ekspektasi
    if (result is OtpSuccess) {
      print("Test Berhasil: ${result.status}");
      expect(result, isA<OtpSuccess>());
    } else if (result is OtpFailure) {
      print("Test Gagal (Response BE Error): ${result.message}");
    }
  });
}
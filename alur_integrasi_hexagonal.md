# Panduan Alur Integrasi Backend dengan Hexagonal Architecture (Flutter)

Dokumentasi ini menjelaskan langkah demi langkah untuk melakukan integrasi fitur/endpoint baru ke backend menggunakan pola **Hexagonal Architecture (Ports and Adapters)** berdasarkan pola kode yang sudah diterapkan pada aplikasi Lazuardy Mobile.

---

## 1. Konsep Dasar Hexagonal Architecture di Flutter

Arsitektur ini memisahkan logika bisnis inti (Domain) dari detail teknis luar (UI, HTTP Client, Database). Arah ketergantungan (dependency) selalu **mengarah ke dalam**:
* **Domain Layer (Inside)**: Bebas dari library eksternal (kecuali core Dart). Berisi logika bisnis inti.
* **Data & Presentation Layer (Outside)**: Berisi detail teknis (Dio, SharedPreferences, UI Widgets). Bergantung pada Domain.

```
       [ Presentation (UI/Cubit) ] (Driving Adapter)
                    │
                    ▼  (Memanggil)
       ┌───────────────────────────────┐
       │         DOMAIN LAYER          │
       │  Usecase (Inbound Port)       │
       │  Entity (Core Data)           │
       │  Repository (Outbound Port)   │ ◄── Interface
       └───────────────────────────────┘
                    ▲
                    │  (Mengimplementasikan)
          [ Data (RepoImpl/DS) ] (Driven Adapter)
```

---

## 2. Langkah-Langkah Integrasi Fitur/Endpoint Baru

Misalkan Anda ingin membuat fitur baru, contoh: **Mengambil Biodata Siswa (`GET /api/student/biodata`)**.

### Langkah 1: Buat Domain Entity (Inti Data)
Buat entity representasi data bisnis murni di `lib/domain/entities/`. Kelas ini tidak boleh memiliki helper parse JSON (`fromJson`/`toJson`) dari library eksternal.

*Contoh:* [student_biodata.dart](file:///d:/Coding/PAD2/lazuadry_mobile_fe/lib/domain/entities/student_biodata.dart)
```dart
class StudentBiodata {
  final String id;
  final String name;
  final String email;

  StudentBiodata({required this.id, required this.name, required this.email});
}
```

### Langkah 2: Buat Outbound Port (Repository Interface)
Buat abstract class sebagai kontrak di `lib/domain/repositories/`.

*Contoh:*
```dart
import '../entities/student_biodata.dart';

abstract class StudentRepository {
  Future<StudentBiodata> getStudentBiodata();
}
```

### Langkah 3: Buat Inbound Port (Usecase)
Buat kelas usecase tunggal di `lib/domain/usecases/` yang memanggil repository interface. Usecase ini merepresentasikan satu fungsi bisnis.

*Contoh:*
```dart
import '../entities/student_biodata.dart';
import '../repositories/student_repository.dart';

class GetStudentBiodataUseCase {
  final StudentRepository repository;

  GetStudentBiodataUseCase(this.repository);

  Future<StudentBiodata> execute() {
    return repository.getStudentBiodata();
  }
}
```

---

### Langkah 4: Buat Data Model / DTO (Adapter)
Buat model di `lib/data/models/` yang mewarisi (extends) dari Domain Entity. Di sinilah helper serialisasi data diletakkan (`fromJson`/`toJson`).

*Contoh:*
```dart
import '../../domain/entities/student_biodata.dart';

class StudentBiodataModel extends StudentBiodata {
  StudentBiodataModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory StudentBiodataModel.fromJson(Map<String, dynamic> json) {
    return StudentBiodataModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}
```

### Langkah 5: Buat/Tambahkan ke Remote Data Source (Adapter)
Tulis pemanggilan endpoint HTTP menggunakan `Dio` atau `ApiClient` di `lib/data/datasources/`.

*Contoh:*
```dart
import 'package:dio/dio.dart';
import '../models/student_biodata_model.dart';

class StudentRemoteDataSource {
  final Dio dio;

  StudentRemoteDataSource(this.dio);

  Future<StudentBiodataModel> fetchStudentBiodata() async {
    final response = await dio.get('/student/biodata');
    return StudentBiodataModel.fromJson(response.data['data']);
  }
}
```

### Langkah 6: Implementasikan Repository Interface (Adapter)
Buat implementasi dari repository domain di `lib/data/repositories/`. Di sini Anda wajib **menangkap exception teknis** (seperti `DioException`) dan mengubahnya menjadi **exception domain** (seperti `ServerException`).

*Contoh:*
```dart
import 'package:dio/dio.dart';
import '../../domain/entities/server_exception.dart';
import '../../domain/entities/student_biodata.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_remote_ds.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl(this.remoteDataSource);

  @override
  Future<StudentBiodata> getStudentBiodata() async {
    try {
      // Mengembalikan model secara aman karena model adalah turunan dari entity
      return await remoteDataSource.fetchStudentBiodata();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Unauthorized');
      }
      throw ServerException(e.message ?? 'Gagal mengambil data biodata.');
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga.');
    }
  }
}
```

---

### Langkah 7: Daftarkan di Dependency Injection
Daftarkan RemoteDataSource, Repository, Usecase, dan Cubit baru Anda di [dependency_injection.dart](file:///d:/Coding/PAD2/lazuadry_mobile_fe/lib/dependency_injection.dart).

```dart
// Data Sources
sl.registerLazySingleton(() => StudentRemoteDataSource(sl()));

// Repositories
sl.registerLazySingleton<StudentRepository>(
  () => StudentRepositoryImpl(sl()),
);

// Usecases
sl.registerLazySingleton(() => GetStudentBiodataUseCase(sl()));
```

---

### Langkah 8: Hubungkan ke State Management (Cubit) & UI Page
Panggil Usecase dari Cubit di layer presentation, lalu gunakan BlocBuilder/BlocConsumer di halaman UI untuk berinteraksi dengan state tersebut.

---

## 3. Aturan Emas & Best Practices Integrasi

1. **Aturan Impor Searah (Golden Rule)**:
   * File di dalam `lib/domain/` **SAMA SEKALI TIDAK BOLEH** mengimpor apapun dari `lib/data/` atau `lib/presentation/`.
   * Melanggar aturan ini merusak esensi Heksagonal dan mempersulit testing/pemeliharaan.
2. **Gunakan Interceptor Token Secara Aman**:
   * Token dibaca secara dinamis dari local storage oleh interceptor di [api_client.dart](file:///d:/Coding/PAD2/lazuadry_mobile_fe/lib/core/network/api_client.dart).
   * Interceptor telah disaring agar **hanya** melampirkan header `Authorization` ke base URL backend kita, sehingga data token tidak bocor ke API publik (seperti API Wilayah Emsifa).
3. **Konversi Error di Repository**:
   * Selalu tangkap `DioException` di kelas `RepositoryImpl` dan ubah menjadi `ServerException`.
   * Presenter (Cubit) dan Usecase hanya boleh mendengarkan `ServerException` sehingga mereka bersih dari ketergantungan library `dio`.

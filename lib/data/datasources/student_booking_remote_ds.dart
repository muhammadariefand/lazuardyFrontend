import 'package:dio/dio.dart';
import '../../domain/entities/server_exception.dart';
import '../models/subject_model.dart';
import '../models/tutor_model.dart';
import '../models/tutor_availability_model.dart';
import '../models/paginated_data_model.dart';

abstract class StudentBookingRemoteDataSource {
  Future<List<String>> getJenjang();
  Future<List<SubjectModel>> getClassesByLevel(String level);
  Future<PaginatedDataModel<TutorModel>> getTutorsByCriteria({
    int? subjectId,
    String? subjectName,
    int? classId,
    String? className,
    String? level,
    double? minRate,
    double? maxRate,
    int page = 1,
  });
  Future<TutorModel> getTutorById(int id);
  Future<PaginatedDataModel<TutorAvailabilityModel>> getTutorSchedulesByDay({
    required int tutorId,
    String? day,
    int page = 1,
  });
  Future<void> takeMeeting({
    required int tutorId,
    required int subjectId,
    required String date,
    required String time,
    required String learningMethod,
    required String address,
  });
}

class StudentBookingRemoteDataSourceImpl implements StudentBookingRemoteDataSource {
  final Dio dio;

  StudentBookingRemoteDataSourceImpl({required this.dio});

  String _extractErrorMessage(DioException e, String fallback) {
    if (e.response?.data != null && e.response?.data is Map) {
      final data = e.response?.data as Map;
      if (data['message'] != null && data['message'].toString().isNotEmpty) {
        return data['message'].toString();
      }
    }
    return fallback;
  }

  @override
  Future<List<String>> getJenjang() async {
    try {
      final response = await dio.get('/jenjang');
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success') {
        final levelData = responseData['level'] as List<dynamic>? ?? [];
        return levelData.map((e) => e.toString()).toList();
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal mengambil data jenjang');
      }
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e, 'Terjadi kesalahan pada server saat mengambil jenjang'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<List<SubjectModel>> getClassesByLevel(String level) async {
    try {
      final response = await dio.get('/getClassByLevel', queryParameters: {'level': level});
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success') {
        final classData = responseData['classes'] as List<dynamic>? ?? [];
        return classData.map((e) => SubjectModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal mengambil data mapel');
      }
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e, 'Terjadi kesalahan pada server saat mengambil mapel'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<PaginatedDataModel<TutorModel>> getTutorsByCriteria({
    int? subjectId,
    String? subjectName,
    int? classId,
    String? className,
    String? level,
    double? minRate,
    double? maxRate,
    int page = 1,
  }) async {
    try {
      final params = <String, dynamic>{'page': page};
      if (subjectId != null) params['subject_id'] = subjectId;
      if (subjectName != null && subjectName.isNotEmpty) params['subject_name'] = subjectName;
      if (classId != null) params['class_id'] = classId;
      if (className != null && className.isNotEmpty) params['class_name'] = className;
      if (level != null && level.isNotEmpty) params['level'] = level;
      if (minRate != null) params['min_rate'] = minRate;
      if (maxRate != null) params['max_rate'] = maxRate;

      final response = await dio.get('/getTutorByCriteria', queryParameters: params);
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success') {
        final dataMap = responseData['data'] as Map<String, dynamic>;
        final listData = dataMap['data'] as List<dynamic>? ?? [];
        final tutors = listData.map((e) => TutorModel.fromJson(e as Map<String, dynamic>)).toList();
        return PaginatedDataModel<TutorModel>.fromJson(dataMap, tutors);
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal mengambil data tutor');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      throw ServerException(_extractErrorMessage(e, 'Terjadi kesalahan pada server saat memuat tutor'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<TutorModel> getTutorById(int id) async {
    try {
      final response = await dio.get('/getTutorById', queryParameters: {'tutor_id': id});
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        return TutorModel.fromJson(data);
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal mengambil detail tutor');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      throw ServerException(_extractErrorMessage(e, 'Terjadi kesalahan pada server saat memuat detail tutor'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<PaginatedDataModel<TutorAvailabilityModel>> getTutorSchedulesByDay({
    required int tutorId,
    String? day,
    int page = 1,
  }) async {
    try {
      final params = <String, dynamic>{
        'tutor_id': tutorId,
        'page': page,
      };
      if (day != null && day.isNotEmpty) {
        params['day'] = day;
      }

      final response = await dio.get('/schedule/getTutorSchedulesByDay', queryParameters: params);
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success') {
        final dataMap = responseData['data'] as Map<String, dynamic>;
        final listData = dataMap['data'] as List<dynamic>? ?? [];
        final schedules = listData.map((e) => TutorAvailabilityModel.fromJson(e as Map<String, dynamic>)).toList();
        return PaginatedDataModel<TutorAvailabilityModel>.fromJson(dataMap, schedules);
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal mengambil jadwal tutor');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      throw ServerException(_extractErrorMessage(e, 'Terjadi kesalahan pada server saat memuat jadwal'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<void> takeMeeting({
    required int tutorId,
    required int subjectId,
    required String date,
    required String time,
    required String learningMethod,
    required String address,
  }) async {
    try {
      final response = await dio.post('/schedule/takeMeeting', data: {
        'tutor_id': tutorId,
        'subject_id': subjectId,
        'date': date,
        'time': time,
        'learning_method': learningMethod,
        'address': address,
      });
      
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status'] != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal melakukan booking');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException('Anda tidak memiliki akses untuk booking tutor');
      }
      if (e.response?.statusCode == 409) {
        throw ServerException('Jadwal ini mungkin sudah terisi atau konflik');
      }
      throw ServerException(_extractErrorMessage(e, 'Terjadi kesalahan pada server saat memproses booking'));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }
}

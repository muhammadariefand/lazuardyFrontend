import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core & Network
import 'package:lazuadry_mobile_fe/core/network/api_client.dart';

// Data Sources
import 'package:lazuadry_mobile_fe/data/datasources/auth_local_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/auth_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/dashboard_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/region_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/schedule_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/report_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/student_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/tutor_dashboard_remote_ds.dart';

// Repositories
import 'package:lazuadry_mobile_fe/data/repositories/auth_repository_impl.dart';
import 'package:lazuadry_mobile_fe/data/repositories/dashboard_repository_impl.dart';
import 'package:lazuadry_mobile_fe/data/repositories/region_repository_impl.dart';
import 'package:lazuadry_mobile_fe/data/repositories/schedule_repository_impl.dart';
import 'package:lazuadry_mobile_fe/data/repositories/report_repository_impl.dart';
import 'package:lazuadry_mobile_fe/data/repositories/student_repository_impl.dart';
import 'package:lazuadry_mobile_fe/data/repositories/tutor_dashboard_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/dashboard_repository.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/region_repository.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/schedule_repository.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/report_repository.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/student_repository.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tutor_dashboard_repository.dart';

// Usecases
import 'package:lazuadry_mobile_fe/domain/usecases/auth/request_otp_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/reset_password_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/get_schedules_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/get_reports_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_districts_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_provinces_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_regencies_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_subdistricts_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_login_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_otp_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_register_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/get_student_biodata_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_tutor_dashboard_usecase.dart';

// State Management / Cubit
import 'package:lazuadry_mobile_fe/presentation/state_management/dashboard/dashboard_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/report/report_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_dashboard/tutor_dashboard_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {

  // ── EXTERNAL ────────────────────────────────────────────────
  // Shared Preferences (di-instansiasi di awal secara async)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // ── CORE & NETWORK ──────────────────────────────────────────
  // 1. Daftarkan ApiClient terlebih dahulu agar dependensinya tersedia
  sl.registerLazySingleton(() => ApiClient(
    getToken: () async {
      try {
        // Mengambil token auth lokal secara aman
        return await sl<AuthLocalDataSource>().getUserToken();
      } catch (_) {
        return null;
      }
    },
  ));

  // 2. Registrasi Dio HTTP Client dengan memanfaatkan instance dari ApiClient
  sl.registerLazySingleton<Dio>(() {
    final dioInstance = sl<ApiClient>().dio;
    
    // Hapus interceptor lama jika ada, lalu pasang pengaman multi-domain yang kebal typo
    dioInstance.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Cek secara pintar: Jika path TIDAK dimulai dengan 'http', atau path-nya mengandung backend Lazuardy
        final isBackendRequest = !options.path.startsWith('http') || 
                                 options.path.contains('lazuardybackend-hexa.onrender.com');

        if (!isBackendRequest) {
          // Jika menembak ke API luar (seperti Emsifa), bersihkan header agar tidak memicu error jembatan
          options.headers.remove('Authorization');
        }
        
        return handler.next(options);
      },
    ));
    
    return dioInstance;
  });

  // ── DATA SOURCES ────────────────────────────────────────────
  // Local Data Source untuk Auth
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Remote Data Source untuk Auth
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  // Remote Data Source untuk Wilayah/Region
  sl.registerLazySingleton<RegionRemoteDataSource>(
    () => RegionRemoteDataSourceImpl(client: sl())
  );

  // Remote Data Source untuk Dashboard
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(dio: sl()),
  );

  // Remote Data Source untuk Schedule
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(dio: sl()),
  );

  // Remote Data Source untuk Report
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(dio: sl()),
  );

  // Remote Data Source untuk Student
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(dio: sl()),
  );

  // Remote Data Source untuk Tutor Dashboard
  sl.registerLazySingleton<TutorDashboardRemoteDataSource>(
    () => TutorDashboardRemoteDataSourceImpl(dio: sl()),
  );

  // ── REPOSITORIES ────────────────────────────────────────────
  // Repository untuk Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Repository untuk Dashboard
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Repository untuk Jadwal
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(remoteDataSource: sl()),
  );

  // Repository untuk Laporan
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(remoteDataSource: sl()),
  );

  // Repository untuk Student
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(remoteDataSource: sl()),
  );

  // Repository untuk Tutor Dashboard
  sl.registerLazySingleton<TutorDashboardRepository>(
    () => TutorDashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Repository untuk Wilayah/Region
  sl.registerLazySingleton<RegionRepository>(
    () => RegionRepositoryImpl(remoteDataSource: sl()),
  );   

  // ── USECASES ────────────────────────────────────────────────
  // Auth Usecases
  sl.registerLazySingleton(() => StudentRegisterOtpEmailUsecase(repository: sl()));
  sl.registerLazySingleton(() => StudentVerifyOtpRegisterEmailUsecase(repository: sl()));
  sl.registerLazySingleton(() => StudentRegisterUsecase(repository: sl()));
  sl.registerLazySingleton(() => StudentLoginUsecase(repository: sl()));
  sl.registerLazySingleton(() => StudentRequestOtpUsecase(sl()));
  sl.registerLazySingleton(() => StudentVerifyOtpUsecase(sl()));
  sl.registerLazySingleton(() => StudentResetPasswordUsecase(sl()));

  // Region/Wilayah Usecases
  sl.registerLazySingleton(() => GetProvincesUseCase(sl()));
  sl.registerLazySingleton(() => GetRegenciesUseCase(sl()));
  sl.registerLazySingleton(() => GetDistrictsUseCase(sl()));
  sl.registerLazySingleton(() => GetSubdistrictsUseCase(sl()));

  // Dashboard Usecases
  sl.registerLazySingleton(() => GetDashboardDataUseCase(sl()));
  sl.registerLazySingleton(() => GetSchedulesUseCase(sl()));
  sl.registerLazySingleton(() => GetReportsUseCase(sl()));

  // Student Usecases
  sl.registerLazySingleton(() => GetStudentBiodataUseCase(sl()));

  // Tutor Usecases
  sl.registerLazySingleton(() => GetTutorDashboardUseCase(sl()));

  // ── PRESENTATION / STATE MANAGEMENT (CUBIT) ──────────────────
  sl.registerFactory(() => AuthCubit(
    studentRegisterOtpEmailUsecase: sl(),
    studentVerifyOtpRegisterEmailUsecase: sl(),
    studentRegisterUsecase: sl(),
    studentLoginUsecase: sl(),
    studentRequestOtpUsecase: sl(),
    studentVerifyOtpUsecase: sl(),
    studentResetPasswordUsecase: sl(),
    ),
  );

  sl.registerFactory(() => RegionCubit(
    sl(), // getProvincesUseCase
    sl(), // getRegenciesUseCase
    sl(), // getDistrictsUseCase
    sl(), // getSubdistrictsUseCase
  ));

  sl.registerFactory(() => DashboardCubit(
    getDashboardDataUseCase: sl(),
    ),
  );

  sl.registerFactory(() => ScheduleCubit(
    getSchedulesUseCase: sl(),
  ));

  sl.registerFactory(() => ReportCubit(
    getReportsUseCase: sl(),
  ));

  sl.registerFactory(() => StudentProfileCubit(
    getStudentBiodataUseCase: sl(),
  ));

  sl.registerFactory(() => TutorDashboardCubit(
    getTutorDashboardUseCase: sl(),
  ));
}

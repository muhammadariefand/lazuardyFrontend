import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/datasources/dashboard_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/region_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/repositories/dashboard_repository_impl.dart';
import 'package:lazuadry_mobile_fe/data/repositories/region_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/dashboard_repository.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/region_repository.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/request_otp_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/reset_password_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_districts_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_provinces_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_regencies_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_subdistricts_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/dashboard/dashboard_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lazuadry_mobile_fe/core/network/api_client.dart';
import 'package:lazuadry_mobile_fe/data/datasources/auth_local_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/auth_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/repositories/auth_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_login_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_otp_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_register_email_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {

  // ── EXTERNAL ────────────────────────────────────────────────
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // Dio HTTP Client (diambil dari ApiClient agar terintegrasi base URL & interceptor)
  sl.registerLazySingleton<Dio>(() => sl<ApiClient>().dio);

  // ── CORE ────────────────────────────────────────────────
  // API Client
  sl.registerLazySingleton(() => ApiClient(
    getToken: () => sl<AuthLocalDataSource>().getUserToken(),
  ));

  // ── DATA SOURCES ────────────────────────────────────────────────
  // Remote 
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  // Remote untuk region
  sl.registerLazySingleton<RegionRemoteDataSource>(
    () => RegionRemoteDataSourceImpl(client: sl())
  );

  // Local untuk auth (penyimpanan token, dsb)
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Remote untuk dashboard
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(dio: sl()),
  );

  // REPOSITORIES ───────────────────────────────────────────────  
  // Repository untuk auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(), 
      localDataSource: sl()
    ),
  );

  // Repository untuk dashboard
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl()),
  );

  // Repository untuk region
  sl.registerLazySingleton<RegionRepository>(
    () => RegionRepositoryImpl(remoteDataSource: sl())
  );  



  // USECASES ───────────────────────────────────────────────
  // Usecases untuk mengirim OTP email saat registrasi
  sl.registerLazySingleton(() => StudentRegisterOtpEmailUsecase(repository: sl()));

  // Usecase untuk verifikasi OTP email saat registrasi
  sl.registerLazySingleton(() => StudentVerifyOtpRegisterEmailUsecase(repository: sl()));

  // Usecase untuk registrasi mahasiswa
  sl.registerLazySingleton(() => StudentRegisterUsecase(repository: sl()));

  // Usecase untuk login mahasiswa
  sl.registerLazySingleton(() => StudentLoginUsecase(repository: sl()));

  // Usecase untuk mengirim OTP
  sl.registerLazySingleton(() => StudentRequestOtpUsecase(sl()));

  // Usecase untuk verifikasi OTP
  sl.registerLazySingleton(() => StudentVerifyOtpUsecase(sl()));

  // Usecase untuk mereset password
  sl.registerLazySingleton(() => StudentResetPasswordUsecase(sl()));

  // Usecase untuk mendapatkan daftar provinsi
  sl.registerLazySingleton(() => GetProvincesUseCase(sl()));

  // Usecase untuk mendapatkan daftar kabupaten/kota berdasarkan provinsi
  sl.registerLazySingleton(() => GetRegenciesUseCase(sl()));

  // Usecase untuk mendapatkan daftar kecamatan berdasarkan kabupaten/kota
  sl.registerLazySingleton(() => GetDistrictsUseCase(sl()));

  // Usecase untuk mendapatkan daftar kelurahan/desa berdasarkan kecamatan
  sl.registerLazySingleton(() => GetSubdistrictsUseCase(sl()));

  // Usecase untuk mendapatkan data dashboard
  sl.registerLazySingleton(() => GetDashboardDataUseCase(sl()));


  // ── PRESENTATION / STATE MANAGEMENT ─────────────────────────
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
    sl(),
    sl(),
    sl(),
    sl(),
  ));

  sl.registerFactory(() => DashboardCubit(
    getDashboardDataUseCase: sl()
    ),
  );
}
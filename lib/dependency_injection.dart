import 'package:get_it/get_it.dart';
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

  // ── CORE ────────────────────────────────────────────────
  // API Client
  sl.registerLazySingleton(() => ApiClient());

  // ── DATA SOURCES ────────────────────────────────────────────────
  // Remote 
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  // Local
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // REPOSITORIES ───────────────────────────────────────────────  
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(), 
      localDataSource: sl()
    ),
  );

  // Usecases untuk mengirim OTP email saat registrasi
  sl.registerLazySingleton(() => StudentRegisterOtpEmailUsecase(repository: sl()));

  // Usecase untuk verifikasi OTP email saat registrasi
  sl.registerLazySingleton(() => StudentVerifyOtpRegisterEmailUsecase(repository: sl()));

  // Usecase untuk registrasi mahasiswa
  sl.registerLazySingleton(() => StudentRegisterUsecase(repository: sl()));

  // Usecase untuk login mahasiswa
  sl.registerLazySingleton(() => StudentLoginUsecase(repository: sl()));

  // ── PRESENTATION / STATE MANAGEMENT ─────────────────────────
  sl.registerFactory(
    () => AuthCubit(
      studentRegisterOtpEmailUsecase: sl(),
      studentVerifyOtpRegisterEmailUsecase: sl(),
      studentRegisterUsecase: sl(),
      studentLoginUsecase: sl(),
    ),
  );
}

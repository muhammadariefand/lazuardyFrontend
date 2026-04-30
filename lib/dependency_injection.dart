import 'package:get_it/get_it.dart';
import 'package:lazuadry_mobile_fe/core/network/api_client.dart';
import 'package:lazuadry_mobile_fe/data/datasources/auth_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/repositories/auth_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_otp_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_register_email_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core 
  sl.registerLazySingleton(() => ApiClient());

  // Data Sources
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  // Repository Implementation 
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => StudentRegisterOtpEmailUsecase(repository: sl()));

  sl.registerLazySingleton(() => StudentVerifyOtpRegisterEmailUsecase(repository: sl()));

  // Presentation / State Management
  sl.registerFactory(
    () => AuthCubit(
      studentRegisterOtpEmailUsecase: sl(),
      studentVerifyOtpRegisterEmailUsecase: sl(),
    ),
  );
}

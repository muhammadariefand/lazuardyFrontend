import 'package:get_it/get_it.dart';
import 'package:lazuadry_mobile_fe/core/network/api_client.dart';
import 'package:lazuadry_mobile_fe/data/datasources/auth_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/repositories/auth_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/login_usecase.dart';
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

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Factory artinya setiap kali dipanggil akan membuat instance baru 
  sl.registerFactory(() => AuthCubit(sl()));
}

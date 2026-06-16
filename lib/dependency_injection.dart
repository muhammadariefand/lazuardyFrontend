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
import 'package:lazuadry_mobile_fe/domain/usecases/auth/register_parent_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/request_otp_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/reset_password_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_tautkan_akun_anak_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/get_schedules_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/get_reports_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/get_parent_profile_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_districts_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_provinces_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_regencies_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_subdistricts_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_login_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_otp_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/register_otp_email_anak_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_register_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/get_student_biodata_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/update_student_biodata_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/update_profile_photo_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_tutor_dashboard_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/update_tutor_biodata_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/update_tutor_profile_photo_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/create_presence_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/siswa/get_student_reviews_usecase.dart';

import 'package:lazuadry_mobile_fe/data/datasources/package_remote_ds.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/package_repository.dart';
import 'package:lazuadry_mobile_fe/data/repositories/package_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/get_packages_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/get_package_detail_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/order_packages_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/package/package_cubit.dart';

// Booking Student
import 'package:lazuadry_mobile_fe/data/datasources/student_booking_remote_ds.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/student_booking_repository.dart';
import 'package:lazuadry_mobile_fe/data/repositories/student_booking_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/student_booking_usecases.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_booking/booking_flow_cubit.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/get_schedule_by_id_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/mark_schedule_complete_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/submit_review_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/riwayat_sesi/riwayat_sesi_cubit.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/cancel_schedule_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/pembatalan_sesi/pembatalan_sesi_cubit.dart';

// Laporan Sesi (Tutor)
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/create_presence_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/laporan_sesi/laporan_sesi_cubit.dart';

// State Management / Cubit
import 'package:lazuadry_mobile_fe/presentation/state_management/dashboard/dashboard_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/report/report_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/parent_profile/parent_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_dashboard/tutor_dashboard_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/ulasan_tutor/ulasan_tutor_cubit.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/confirm_booking_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/booking_confirmation_cubit.dart';

// Tutor Profile
import 'package:lazuadry_mobile_fe/data/datasources/tutor_profile_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/repositories/tutor_profile_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tutor_profile_repository.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_tutor_profile_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_profile/tutor_profile_cubit.dart';

import 'package:lazuadry_mobile_fe/presentation/state_management/ulasan_siswa/ulasan_siswa_cubit.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_tutor_reviews_usecase.dart';

// Tutor: Tarik Saldo
import 'package:lazuadry_mobile_fe/data/datasources/tarik_saldo_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/repositories/tarik_saldo_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tarik_saldo_repository.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_payout_history_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/take_money_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tarik_saldo/tarik_saldo_cubit.dart';

// Tutor: Profil Mengajar
import 'package:lazuadry_mobile_fe/data/datasources/profil_mengajar_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/repositories/profil_mengajar_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/profil_mengajar_repository.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_tutor_schedules_usecase.dart'; // the file name is still the same
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/update_teaching_profile_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/profil_mengajar/profil_mengajar_cubit.dart';

// Parent Dashboard
import 'package:lazuadry_mobile_fe/data/datasources/parent_dashboard_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/repositories/parent_dashboard_repository_impl.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/parent_dashboard_repository.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/parent/get_parent_dashboard_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/parent_dashboard/parent_dashboard_cubit.dart';

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
  sl.registerLazySingleton<StudentBookingRemoteDataSource>(
    () => StudentBookingRemoteDataSourceImpl(dio: sl()),
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

  // Remote Data Source untuk Package
  sl.registerLazySingleton<PackageRemoteDataSource>(
    () => PackageRemoteDataSourceImpl(dio: sl()),
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
  sl.registerLazySingleton<StudentBookingRepository>(
    () => StudentBookingRepositoryImpl(remoteDataSource: sl()),
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

  // Repository untuk Package
  sl.registerLazySingleton<PackageRepository>(
    () => PackageRepositoryImpl(remoteDataSource: sl()),
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
  sl.registerLazySingleton(() => GetStudentReviewsUseCase(sl()));

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
  sl.registerLazySingleton(() => UpdateStudentBiodataUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfilePhotoUseCase(sl()));
  sl.registerLazySingleton(() => RegisterOtpEmailAnakUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetPackagesUseCase(sl()));
  sl.registerLazySingleton(() => GetPackageDetailUseCase(sl()));
  sl.registerLazySingleton(() => OrderPackagesUseCase(sl()));

  // Student Booking
  sl.registerLazySingleton(() => GetJenjangUseCase(sl()));
  sl.registerLazySingleton(() => GetClassesByLevelUseCase(sl()));
  sl.registerLazySingleton(() => GetTutorsByCriteriaUseCase(sl()));
  sl.registerLazySingleton(() => GetTutorByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetTutorSchedulesUseCase(sl()));
  sl.registerLazySingleton(() => TakeMeetingUseCase(sl()));

  // Riwayat Sesi
  sl.registerLazySingleton(() => GetScheduleByIdUseCase(sl()));
  sl.registerLazySingleton(() => MarkScheduleCompleteUseCase(sl()));
  sl.registerLazySingleton(() => SubmitReviewUseCase(sl()));

  sl.registerLazySingleton(() => VerifyOtpTautkanAkunAnakUsecase(repository: sl()));

  sl.registerLazySingleton(() => RegisterParentUsecase(repository: sl()));

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
    registerOtpEmailAnakUsecase: sl(),
    verifyOtpTautkanAkunAnakUsecase: sl(),
    registerParentUsecase: sl(),
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

  sl.registerFactory(() => ReportCubit(
    getReportsUseCase: sl(),
  ));

  sl.registerFactory(() => ScheduleCubit(
    getSchedulesUseCase: sl(),
  ));


  sl.registerFactory(() => StudentProfileCubit(
    getStudentBiodataUseCase: sl(),
    updateStudentBiodataUseCase: sl(),
    updateProfilePhotoUseCase: sl(),
  ));

  sl.registerFactory(() => PackageCubit(
    getPackagesUseCase: sl(),
    getPackageDetailUseCase: sl(),
    orderPackagesUseCase: sl(),
  ));

  sl.registerFactory(() => BookingFlowCubit(
    getJenjangUseCase: sl(),
    getClassesByLevelUseCase: sl(),
    getTutorsByCriteriaUseCase: sl(),
    getTutorByIdUseCase: sl(),
    getTutorSchedulesUseCase: sl(),
    takeMeetingUseCase: sl(),
  ));

  sl.registerFactory(() => RiwayatSesiCubit(
    getSchedulesUseCase: sl(),
    getScheduleByIdUseCase: sl(),
    markScheduleCompleteUseCase: sl(),
    submitReviewUseCase: sl(),
  ));

  // Tutor: Pembatalan Sesi
  sl.registerLazySingleton(() => CancelScheduleUseCase(sl()));
  sl.registerFactory(() => PembatalanSesiCubit(
    getScheduleByIdUseCase: sl(),
    cancelScheduleUseCase: sl(),
  ));

  // Tutor: Laporan Sesi
  sl.registerLazySingleton(() => CreatePresenceUseCase(sl()));
  sl.registerFactory(() => LaporanSesiCubit(
    createPresenceUseCase: sl(),
  ));

  sl.registerFactory(() => ParentProfileCubit(
    getParentProfileUseCase: sl(),
  ));

  sl.registerFactory(() => TutorDashboardCubit(
    getTutorDashboardUseCase: sl(),
  ));

  sl.registerLazySingleton(() => ConfirmBookingUseCase(sl()));

  sl.registerLazySingleton(() => GetParentProfileUseCase(sl()));

  sl.registerFactory(() => BookingConfirmationCubit(
    confirmBookingUseCase: sl(),
  ));

  // Tutor Profile
  sl.registerLazySingleton<TutorProfileRemoteDataSource>(
    () => TutorProfileRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<TutorProfileRepository>(
    () => TutorProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetTutorProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTutorBiodataUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTutorProfilePhotoUseCase(sl()));
  sl.registerFactory(() => TutorProfileCubit(
    getTutorProfileUseCase: sl(),
    updateTutorBiodataUseCase: sl(),
    updateTutorProfilePhotoUseCase: sl(),
  ));

  // Parent Dashboard
  sl.registerLazySingleton<ParentDashboardRemoteDataSource>(
    () => ParentDashboardRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ParentDashboardRepository>(
    () => ParentDashboardRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetParentDashboardUseCase(sl()));
  sl.registerFactory(() => ParentDashboardCubit(
    getDashboardUseCase: sl(),
  ));

  // Siswa: Ulasan Tutor
  sl.registerFactory(() => UlasanTutorCubit(
    getStudentReviewsUseCase: sl(),
  ));

  // Tutor: Ulasan Siswa
  sl.registerLazySingleton(() => GetTutorReviewsUseCase(sl()));
  sl.registerFactory(() => UlasanSiswaCubit(
    getTutorReviewsUseCase: sl(),
  ));

  // Tutor: Tarik Saldo
  sl.registerLazySingleton<TarikSaldoRemoteDataSource>(
    () => TarikSaldoRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<TarikSaldoRepository>(
    () => TarikSaldoRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetPayoutHistoryUseCase(sl()));
  sl.registerLazySingleton(() => TakeMoneyUseCase(sl()));
  sl.registerFactory(() => TarikSaldoCubit(
    getTutorProfileUseCase: sl(),
    getPayoutHistoryUseCase: sl(),
    takeMoneyUseCase: sl(),
  ));

  // Tutor: Profil Mengajar
  sl.registerLazySingleton<ProfilMengajarRemoteDataSource>(
    () => ProfilMengajarRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ProfilMengajarRepository>(
    () => ProfilMengajarRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetTeachingSchedulesUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTeachingProfileUseCase(sl()));
  sl.registerFactory(() => ProfilMengajarCubit(
    getTutorProfileUseCase: sl(),
    getTutorSchedulesUseCase: sl(),
    updateTeachingProfileUseCase: sl(),
  ));
}

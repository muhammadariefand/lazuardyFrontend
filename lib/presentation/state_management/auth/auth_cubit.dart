import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/auth/register_student_request.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/register_otp_email_anak_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/register_parent_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/request_otp_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/reset_password_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_login_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_otp_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_register_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_tautkan_akun_anak_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final StudentRegisterOtpEmailUsecase studentRegisterOtpEmailUsecase;
  final StudentVerifyOtpRegisterEmailUsecase
  studentVerifyOtpRegisterEmailUsecase;
  final StudentRegisterUsecase studentRegisterUsecase;
  final StudentLoginUsecase studentLoginUsecase;
  final StudentRequestOtpUsecase studentRequestOtpUsecase;
  final StudentVerifyOtpUsecase studentVerifyOtpUsecase;
  final StudentResetPasswordUsecase studentResetPasswordUsecase;
  final RegisterOtpEmailAnakUsecase registerOtpEmailAnakUsecase;
  final VerifyOtpTautkanAkunAnakUsecase verifyOtpTautkanAkunAnakUsecase;
  final RegisterParentUsecase registerParentUsecase;

  AuthCubit({
    required this.studentRegisterOtpEmailUsecase,
    required this.studentVerifyOtpRegisterEmailUsecase,
    required this.studentRegisterUsecase,
    required this.studentLoginUsecase,
    required this.studentRequestOtpUsecase,
    required this.studentVerifyOtpUsecase,
    required this.studentResetPasswordUsecase,
    required this.registerOtpEmailAnakUsecase,
    required this.verifyOtpTautkanAkunAnakUsecase,
    required this.registerParentUsecase
  }) : super(AuthInitial());

  Future<void> registerOtpEmail(String email) async {
    emit(AuthLoading());
    try {
      await studentRegisterOtpEmailUsecase.execute(email);
      emit(RegisterOtpEmailSuccess());
    } on ServerException catch (e) {
      emit(AuthFailure(e.message, errorDetails: e.errors));
    } catch (e) {
      emit(AuthFailure("Terjadi kesalahan yang tidak diketahui"));
    }
  }

  Future<void> studentRegisterOtpEmail(String email) async {
    emit(AuthLoading());
    try {
      await studentRegisterOtpEmailUsecase.execute(email);
      emit(RegisterOtpEmailSuccess()); // State spesifik, bukan AuthSuccess
    } on ServerException catch (e) {
      emit(AuthFailure(e.message, errorDetails: e.errors));
    } catch (e) {
      emit(AuthFailure("Terjadi kesalahan yang tidak diketahui"));
    }
  }

  Future<void> verifyOtpEmail({
    required String email,
    required String otp,
  }) async {
    emit(AuthLoading());
    try {
      await studentVerifyOtpRegisterEmailUsecase.execute(email, otp);
      emit(
        VerifyOtpRegisterEmailSuccess(),
      ); // State spesifik, bukan AuthSuccess
    } on ServerException catch (e) {
      emit(AuthFailure(e.message, errorDetails: e.errors));
    } catch (e) {
      emit(AuthFailure("Terjadi kesalahan sistem"));
    }
  }

  Future<void> studentVerifyOtpRegisterEmail({
    required String email,
    required String otp,
  }) async {
    emit(AuthLoading());
    try {
      await studentVerifyOtpRegisterEmailUsecase.execute(email, otp);
      emit(
        VerifyOtpRegisterEmailSuccess(),
      ); // State spesifik, bukan AuthSuccess
    } on ServerException catch (e) {
      emit(AuthFailure(e.message, errorDetails: e.errors));
    } catch (e) {
      emit(AuthFailure("Terjadi kesalahan sistem"));
    }
  }

  Future<void> studentRegister(RegisterStudentRequest request) async {
    emit(AuthLoading());
    try {
      await studentRegisterUsecase.execute(request);
      emit(RegisterStudentSuccess()); // State spesifik, bukan AuthSuccess
    } on ServerException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure("Terjadi kesalahan yang tidak diketahui"));
    }
  }

  Future<void> studentLogin(String email, String password) async {
    emit(AuthLoading());
    try {
      await studentLoginUsecase.execute(email, password);
      emit(AuthSuccess());
    } on ServerException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> studentRequestOtp(String email) async {
    emit(AuthLoading());
    try {
      await studentRequestOtpUsecase.execute(email);
      emit(OtpSentSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> studentVerifyOtp(String email, String otp) async {
    emit(AuthLoading());
    try {
      final token = await studentVerifyOtpUsecase.execute(email, otp);
      emit(OtpVerifiedSuccess(token));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> studentResetPassword({
    required String email,
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    try {
      await studentResetPasswordUsecase.execute(
        email: email,
        resetToken: token,
        password: password,
        confirmPassword: confirmPassword,
      );
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> registerOtpAkunAnak(String childEmail) async {
    emit(AuthLoading());
    try {
      await registerOtpEmailAnakUsecase.execute(childEmail);
      emit(RegisterOtpEmailSuccess());
    } on ServerException catch (e) {
      emit(AuthFailure(e.message, errorDetails: e.errors));
    } catch (e) {
      emit(AuthFailure("Terjadi kesalahan yang tidak diketahui"));
    }
  }

  Future<void> verifyOtpAkunAnakAndRegisterParent({
    required String email,
    required String password,
    required String childEmail,
    required String otp,
  }) async {
    emit(AuthLoading());
    try {
      await verifyOtpTautkanAkunAnakUsecase.execute(childEmail, otp);
      await registerParentUsecase.execute(
        email,
        password,
        childEmail,
      );
      emit(RegisterOtpEmailSuccess());
    } on ServerException catch (e) {
      emit(AuthFailure(e.message, errorDetails: e.errors));
    } catch (e) {
      emit(AuthFailure("Terjadi kesalahan yang tidak diketahui"));
    }
  }
}

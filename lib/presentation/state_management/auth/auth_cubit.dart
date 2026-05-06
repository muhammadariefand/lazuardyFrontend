import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/data/models/auth/register_student_request.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_login_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_otp_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_register_email_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final StudentRegisterOtpEmailUsecase studentRegisterOtpEmailUsecase;
  final StudentVerifyOtpRegisterEmailUsecase studentVerifyOtpRegisterEmailUsecase;
  final StudentRegisterUsecase studentRegisterUsecase;
  final StudentLoginUsecase studentLoginUsecase;

  AuthCubit({
    required this.studentRegisterOtpEmailUsecase,
    required this.studentVerifyOtpRegisterEmailUsecase,
    required this.studentRegisterUsecase,
    required this.studentLoginUsecase,
  }) : super(AuthInitial());

  Future<void> studentRegisterOtpEmail(String email) async {
    emit(AuthLoading());
    try {
      await studentRegisterOtpEmailUsecase.execute(email);
      emit(AuthSuccess());
    } on ServerException catch (e) {
    emit(AuthFailure(e.message, errorDetails: e.errors)); // UI menampilkan error
  } catch (e) {
    emit(AuthFailure("Terjadi kesalahan yang tidak diketahui"));
    }
  }

  Future<void> studentVerifyOtpRegisterEmail({required String email, required String otp}) async {
    emit(AuthLoading());
    try {
      await studentVerifyOtpRegisterEmailUsecase.execute(email, otp);
      emit(AuthSuccess());
    } on ServerException catch (e) {
      emit(AuthFailure(e.message, errorDetails: e.errors)); // UI menampilkan error  
    } catch (e) {
      emit(AuthFailure("Terjadi kesalahan sistem"));
    }
  }
  Future<void> studentRegister(RegisterStudentRequest request) async {
    emit(AuthLoading());
    try {
      await studentRegisterUsecase.execute(request);
      emit(AuthSuccess());
    } on ServerException catch (e) {
      emit(AuthFailure(e.message));
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
      emit (AuthFailure(e.toString()));
    }
  }
}
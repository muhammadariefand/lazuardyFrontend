import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_otp_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_register_email_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final StudentRegisterOtpEmailUsecase studentRegisterOtpEmailUsecase;
  final StudentVerifyOtpRegisterEmailUsecase studentVerifyOtpRegisterEmailUsecase;

  AuthCubit({
    required this.studentRegisterOtpEmailUsecase,
    required this.studentVerifyOtpRegisterEmailUsecase,
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
}
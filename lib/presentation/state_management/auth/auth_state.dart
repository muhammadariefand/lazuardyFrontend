abstract class AuthState{}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure extends AuthState {
  final String error;
  final Map<String, dynamic>? errorDetails; // Tambahkan ini untuk menampung detail error

  AuthFailure(this.error, {this.errorDetails});
}

class OtpSentSuccess extends AuthState {}
class OtpVerifiedSuccess extends AuthState {
  final String resetToken;
  OtpVerifiedSuccess(this.resetToken);
}
class ResetPasswordSuccess extends AuthState {}

// States untuk langkah-langkah registrasi siswa
class RegisterOtpEmailSuccess extends AuthState {}
class VerifyOtpRegisterEmailSuccess extends AuthState {}
class RegisterStudentSuccess extends AuthState {}

// State untuk OAuth login jika belum punya akun
class AuthOAuthRegistrationRequired extends AuthState {
  final Map<String, dynamic> profileData;
  AuthOAuthRegistrationRequired(this.profileData);
}
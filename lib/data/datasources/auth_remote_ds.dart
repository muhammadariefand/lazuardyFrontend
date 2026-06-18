import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/core/enums/role_enum.dart';
import 'package:lazuadry_mobile_fe/core/network/api_client.dart';
import 'package:lazuadry_mobile_fe/domain/entities/auth/register_student_request.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';

class AuthRemoteDataSource {
  final ApiClient client;
  AuthRemoteDataSource(this.client);

  // Future<UserModel> login(String email, String password) async {
  //   final response = await client.dio.post('/login', data: {
  //     'email': email,
  //     'password': password,
  //   });

  //   return UserModel.fromJson(response.data['user']);
  // }

  Future<void> studentRegisterOtpEmail(String email) async {
    try {
      await client.dio.post('/registerOtpEmail', data: {'email': email});
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        throw ServerException(
          data['message'] ?? 'Validasi gagal',
          errors: data['errors'],
        );
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Server sedang gangguan, coba lagi nanti.');
      } else {
        throw ServerException('Terjadi kesalahan yang tidak diketahui.');
      }
    }
  }

  Future<void> registerOtpEmail(String email) async {
    try {
      await client.dio.post('/registerOtpEmail', data: {'email': email});
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        throw ServerException(
          data['message'] ?? 'Validasi gagal',
          errors: data['errors'],
        );
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Server sedang gangguan, coba lagi nanti.');
      } else {
        throw ServerException('Terjadi kesalahan yang tidak diketahui.');
      }
    }
  }

  Future<void> studentVerifyOtpRegisterEmail({
    required String email,
    required String otp,
  }) async {
    try {
      await client.dio.post(
        '/verifyOtpRegisterEmail',
        data: {'email': email, 'otp': otp},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        throw ServerException(
          data['message'] ?? 'Validasi gagal',
          errors: data['errors'],
        );
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Server sedang gangguan, coba lagi nanti.');
      } else {
        throw ServerException('Terjadi kesalahan yang tidak diketahui.');
      }
    }
  }

  Future<Map<String, dynamic>> studentRegister(
    RegisterStudentRequest request,
  ) async {
    try {
      final response = await client.dio.post(
        '/studentRegister',
        data: request.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> studentLogin(
    String email,
    String password,
  ) async {
    try {
      final response = await client.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Forgot password: request OTP
  Future<void> studentForgotPasswordRequest(String email) async {
    try {
      await client.dio.post('/forgotPasswordOtpEmail', data: {'email': email});
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // Verify OTP for forgot password, return reset token from server
  Future<String> studentForgotPasswordVerify(String email, String otp) async {
    try {
      final response = await client.dio.post(
        '/forgotPasswordVerifyOtpEmail',
        data: {'email': email, 'otp': otp},
      );
      return response.data['reset_token'] ?? '';
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Reset password using reset token
  Future<void> studentForgotPasswordReset({
    required String email,
    required String resetToken,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      await client.dio.post(
        '/forgotPasswordResetPassword',
        data: {
          'email': email,
          'reset_token': resetToken,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        throw ServerException(
          data['message'] ?? 'Validasi gagal',
          errors: data['errors'],
        );
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Email atau password salah.');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Server sedang gangguan, coba lagi nanti.');
      } else {
        throw ServerException('Terjadi kesalahan yang tidak diketahui.');
      }
    }
  }

  Future<void> registerOtpEmailAnak(String childEmail) async {
    try {
      await client.dio.post(
        '/register-otp/student-parents',
        data: {'email': childEmail},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        throw ServerException(
          data['message'] ??
              'Terjadi kesalahan validasi email anak, coba lagi nanti.',
          errors: data['errors'],
        );
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Server sedang gangguan, coba lagi nanti.');
      } else {
        throw ServerException('Terjadi kesalahan yang tidak diketahui.');
      }
    }
  }

  Future<void> verifyOtpTautkanAkunAnak(String childEmail, String otp) async {
    try {
      await client.dio.post(
        '/verify-otp/student-parents',
        data: {'email': childEmail, 'otp': otp},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422 ||
          e.response?.statusCode == 403 ||
          e.response?.statusCode == 404) {
        final data = e.response?.data;
        throw ServerException(
          data['message'] ??
              'Terjadi kesalahan validasi OTP tautkan akun anak, coba lagi nanti.',
          errors: data['errors'],
        );
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Server sedang gangguan, coba lagi nanti.');
      } else {
        throw ServerException('Terjadi kesalahan yang tidak diketahui.');
      }
    }
  }

  Future<void> registerParent(
    String email,
    String password,
    String childEmail,
  ) async {
    try {
      await client.dio.post(
        '/register/parent',
        data: {'email': email, 'password': password, 'child_email': childEmail},
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  void _handleDioError(DioException e) {
    if (e.response?.statusCode == 422) {
      final data = e.response?.data;
      throw ServerException(
        data['message'] ?? 'Validasi gagal',
        errors: data['errors'],
      );
    } else if (e.response?.statusCode == 500) {
      throw ServerException('Server sedang gangguan, coba lagi nanti.');
    } else {
      throw ServerException('Terjadi kesalahan yang tidak diketahui.');
    }
  }

  Future<Map<String, dynamic>> oauthCallback(String provider, String idToken) async {
    try {
      final response = await client.dio.post(
        '/auth/$provider/callback',
        data: {'id_token': idToken},
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }
}

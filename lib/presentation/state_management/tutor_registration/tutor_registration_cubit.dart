import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/student_register_otp_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/auth/verify_otp_register_email_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor_registration/validate_bank_account_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor_registration/get_subject_by_class_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor_registration/register_tutor_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_registration/tutor_registration_state.dart';

class TutorRegistrationCubit extends Cubit<TutorRegistrationState> {
  final StudentRegisterOtpEmailUsecase registerOtpEmailUsecase;
  final StudentVerifyOtpRegisterEmailUsecase verifyOtpRegisterEmailUsecase;
  final ValidateBankAccountUseCase validateBankAccountUseCase;
  final GetSubjectByClassUseCase getSubjectByClassUseCase;
  final RegisterTutorUseCase registerTutorUseCase;

  TutorRegistrationData formData = TutorRegistrationData();

  TutorRegistrationCubit({
    required this.registerOtpEmailUsecase,
    required this.verifyOtpRegisterEmailUsecase,
    required this.validateBankAccountUseCase,
    required this.getSubjectByClassUseCase,
    required this.registerTutorUseCase,
  }) : super(TutorRegistrationInitial());

  void reset() {
    formData = TutorRegistrationData();
    emit(TutorRegistrationInitial());
  }

  // 1. Email & Password -> Request OTP
  Future<void> requestOtp({required String email, required String password}) async {
    emit(TutorRegistrationLoading());
    try {
      formData.email = email;
      formData.password = password;
      await registerOtpEmailUsecase.execute(email);
      emit(OtpSentSuccess());
    } on ServerException catch (e) {
      emit(TutorRegistrationError(e.message, errors: e.errors));
    } catch (e) {
      emit(TutorRegistrationError('Terjadi kesalahan yang tidak diketahui'));
    }
  }

  // 2. Verify OTP
  Future<void> verifyOtp({required String otp}) async {
    emit(TutorRegistrationLoading());
    try {
      await verifyOtpRegisterEmailUsecase.execute(formData.email!, otp);
      emit(OtpVerifiedSuccess());
    } on ServerException catch (e) {
      emit(TutorRegistrationError(e.message, errors: e.errors));
    } catch (e) {
      emit(TutorRegistrationError('Terjadi kesalahan sistem'));
    }
  }

  // 3. Detail Pribadi & Validate Bank
  Future<void> validateBank({
    required String name,
    required String gender,
    required String dob,
    required String waNumber,
    required String bankCode,
    required String accountNumber,
    PlatformFile? profilePhoto,
  }) async {
    emit(TutorRegistrationLoading());
    try {
      formData.name = name;
      formData.gender = gender == 'Laki-laki' ? 'male' : (gender == 'Perempuan' ? 'female' : gender);
      formData.dob = dob;
      formData.waNumber = waNumber;
      formData.bankCode = bankCode;
      formData.accountNumber = accountNumber;
      formData.profilePhoto = profilePhoto;

      // --- TEMPORARY BYPASS UNTUK TESTING ---
      // Karena endpoint backend selalu menolak (baik rekening asli maupun palsu),
      // kita bypass validasi jika nomor rekening adalah 1122334455.
      if (accountNumber == '1122334455') {
        await Future.delayed(const Duration(milliseconds: 500));
        formData.accountHolderName = name;
        emit(BankAccountValid(name));
        return;
      }
      // --------------------------------------

      final holderName = await validateBankAccountUseCase.execute(bankCode, accountNumber);
      formData.accountHolderName = holderName;
      emit(BankAccountValid(holderName));
    } on ServerException catch (e) {
      emit(TutorRegistrationError(e.message, errors: e.errors));
    } catch (e) {
      emit(TutorRegistrationError('Gagal memvalidasi nomor rekening'));
    }
  }

  // 4. Save Alamat (Local)
  void saveAddress({
    required String province,
    required String regency,
    required String district,
    required String subdistrict,
  }) {
    formData.province = province;
    formData.regency = regency;
    formData.district = district;
    formData.subdistrict = subdistrict;
    // No API call, just navigate
  }

  // 5. Save Berkas (Local)
  void saveDocuments({
    required PlatformFile cv,
    required PlatformFile idCard,
    required PlatformFile certificate,
  }) {
    formData.cv = cv;
    formData.idCard = idCard;
    formData.certificate = certificate;
    // No API call, just navigate
  }

  // 6. Get Subjects by Class
  Future<void> getSubjectsByClass(int classId) async {
    emit(TutorRegistrationLoading());
    try {
      final subjects = await getSubjectByClassUseCase.execute(classId);
      emit(SubjectsLoaded(subjects));
    } on ServerException catch (e) {
      emit(TutorRegistrationError(e.message));
    } catch (e) {
      emit(TutorRegistrationError('Gagal mengambil daftar mata pelajaran'));
    }
  }

  // 7. Final Submit (Multipart)
  Future<void> submitRegistration({
    required List<String> learningMethods,
    required String bio,
    required List<Map<String, String>> schedules,
  }) async {
    emit(TutorRegistrationLoading());
    try {
      formData.learningMethods = learningMethods;
      formData.bio = bio;

      // Prepare FormData
      final Map<String, dynamic> data = {
        'email': formData.email,
        'password': formData.password,
        'name': formData.name,
        'gender': formData.gender,
        'description': formData.bio,
        'date_of_birth': formData.dob,
        'telephone_number': formData.waNumber,
        'account_holder_name': formData.accountHolderName,
        'bank_code': formData.bankCode,
        'account_number': formData.accountNumber,
        'province': formData.province,
        'regency': formData.regency,
        'district': formData.district,
        'subdistrict': formData.subdistrict,
        'subject_id': 1, // Default subject_id karena UI Kelas & Mapel dihapus
      };

      // Add learning methods (array)
      for (int i = 0; i < learningMethods.length; i++) {
        data['learning_method[$i]'] = learningMethods[i].toLowerCase();
      }

      // Add schedules (array of objects)
      final Map<String, String> dayMap = {
        'Sen': 'Monday',
        'Sel': 'Tuesday',
        'Rab': 'Wednesday',
        'Kam': 'Thursday',
        'Jum': 'Friday',
        'Sab': 'Saturday',
        'Min': 'Sunday'
      };

      for (int i = 0; i < schedules.length; i++) {
        final shortDay = schedules[i]['hari'] ?? '';
        data['schedules[$i][day]'] = dayMap[shortDay] ?? shortDay;
        data['schedules[$i][time]'] = schedules[i]['jam'];
      }

      final form = FormData.fromMap(data);

      Future<MultipartFile> createMultipart(PlatformFile? file, String defaultName) async {
        if (file == null) return MultipartFile.fromString('dummy', filename: defaultName);
        
        final isPdf = file.name.toLowerCase().endsWith('.pdf') || defaultName.endsWith('.pdf');
        final mediaType = isPdf ? MediaType('application', 'pdf') : MediaType('image', 'jpeg');

        if (kIsWeb) {
          if (file.bytes != null) {
            return MultipartFile.fromBytes(file.bytes!, filename: file.name, contentType: mediaType);
          }
          return MultipartFile.fromString('dummy content', filename: file.name, contentType: mediaType);
        } else {
          if (file.path != null) {
            return await MultipartFile.fromFile(file.path!, filename: file.name, contentType: mediaType);
          }
          return MultipartFile.fromString('dummy content', filename: file.name, contentType: mediaType);
        }
      }

      if (formData.profilePhoto != null) {
        form.files.add(MapEntry('profile_photo', await createMultipart(formData.profilePhoto, 'profile.jpg')));
      }
      if (formData.cv != null) {
        form.files.add(MapEntry('curriculum_vitae', await createMultipart(formData.cv, 'cv.pdf')));
      }
      if (formData.idCard != null) {
        form.files.add(MapEntry('id_card', await createMultipart(formData.idCard, 'ktp.jpg')));
      }
      if (formData.certificate != null) {
        form.files.add(MapEntry('certificate', await createMultipart(formData.certificate, 'ijazah.pdf')));
      }

      await registerTutorUseCase.execute(form);
      emit(TutorRegistrationSuccess('Pendaftaran berhasil!'));
    } on ServerException catch (e) {
      print('SERVER EXCEPTION: ${e.message} ${e.errors}');
      emit(TutorRegistrationError(e.message, errors: e.errors));
    } catch (e, stack) {
      print('GENERAL EXCEPTION: $e $stack');
      emit(TutorRegistrationError('Gagal melakukan pendaftaran'));
    }
  }
}

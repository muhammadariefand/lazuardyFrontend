import 'package:lazuadry_mobile_fe/domain/repositories/tutor_registration_repository.dart';

class ValidateBankAccountUseCase {
  final TutorRegistrationRepository repository;

  ValidateBankAccountUseCase(this.repository);

  Future<String> execute(String bankCode, String accountNumber) async {
    return await repository.validateBankAccount(bankCode, accountNumber);
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class UpdateProfileUseCase {
  final SettingsRepository repository;

  UpdateProfileUseCase({required this.repository});

  Future<Either<ErrorModel, void>> call(String firstName, String lastName, String phoneNumber) {
    return repository.updateProfile(firstName, lastName, phoneNumber);
  }
}

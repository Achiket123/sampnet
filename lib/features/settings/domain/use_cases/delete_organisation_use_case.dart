import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class DeleteOrganisationUseCase {
  final SettingsRepository repository;

  DeleteOrganisationUseCase({required this.repository});

  Future<Either<ErrorModel, void>> call() {
    return repository.deleteOrganisation();
  }
}

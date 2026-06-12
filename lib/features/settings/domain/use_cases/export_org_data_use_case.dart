import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class ExportOrgDataUseCase {
  final SettingsRepository repository;

  ExportOrgDataUseCase({required this.repository});

  Future<Either<ErrorModel, String>> call() {
    return repository.exportOrgData();
  }
}

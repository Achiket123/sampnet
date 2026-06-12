import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/org_settings_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class GetOrgSettingsUseCase {
  final SettingsRepository repository;

  GetOrgSettingsUseCase({required this.repository});

  Future<Either<ErrorModel, OrgSettings>> call() {
    return repository.getOrgSettings();
  }
}

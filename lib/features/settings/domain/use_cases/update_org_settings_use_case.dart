import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/org_settings_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class UpdateOrgSettingsUseCase {
  final SettingsRepository repository;

  UpdateOrgSettingsUseCase({required this.repository});

  Future<Either<ErrorModel, OrgSettings>> call(OrgSettings settings) {
    return repository.updateOrgSettings(settings);
  }
}

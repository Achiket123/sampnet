import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/role_permissions_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class UpdateRolePermissionsUseCase {
  final SettingsRepository repository;

  UpdateRolePermissionsUseCase({required this.repository});

  Future<Either<ErrorModel, void>> call(List<RolePermissions> permissions) {
    return repository.updateRolePermissions(permissions);
  }
}

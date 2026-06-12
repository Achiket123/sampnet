import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/role_permissions_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class GetRolePermissionsUseCase {
  final SettingsRepository repository;

  GetRolePermissionsUseCase({required this.repository});

  Future<Either<ErrorModel, List<RolePermissions>>> call() {
    return repository.getRolePermissions();
  }
}

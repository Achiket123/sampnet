import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/leave_policy_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class UpdateLeavePoliciesUseCase {
  final SettingsRepository repository;

  UpdateLeavePoliciesUseCase({required this.repository});

  Future<Either<ErrorModel, void>> call(List<LeaveTypeConfig> policies) {
    return repository.updateLeavePolicies(policies);
  }
}

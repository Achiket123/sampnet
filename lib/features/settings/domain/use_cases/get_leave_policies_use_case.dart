import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/leave_policy_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class GetLeavePoliciesUseCase {
  final SettingsRepository repository;

  GetLeavePoliciesUseCase({required this.repository});

  Future<Either<ErrorModel, List<LeaveTypeConfig>>> call() {
    return repository.getLeavePolicies();
  }
}

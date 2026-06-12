import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/attendance_policy_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class UpdateAttendancePolicyUseCase {
  final SettingsRepository repository;

  UpdateAttendancePolicyUseCase({required this.repository});

  Future<Either<ErrorModel, AttendancePolicyConfig>> call(AttendancePolicyConfig policy) {
    return repository.updateAttendancePolicy(policy);
  }
}

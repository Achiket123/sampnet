import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/plan_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class GetOrgPlanUseCase {
  final SettingsRepository repository;

  GetOrgPlanUseCase({required this.repository});

  Future<Either<ErrorModel, OrgPlan>> call() {
    return repository.getOrgPlan();
  }
}

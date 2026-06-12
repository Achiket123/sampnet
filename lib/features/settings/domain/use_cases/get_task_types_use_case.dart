import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/task_type_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class GetTaskTypesUseCase {
  final SettingsRepository repository;

  GetTaskTypesUseCase({required this.repository});

  Future<Either<ErrorModel, List<TaskTypeConfig>>> call() {
    return repository.getTaskTypes();
  }
}

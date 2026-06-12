import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class DeleteTaskTypeUseCase {
  final SettingsRepository repository;

  DeleteTaskTypeUseCase({required this.repository});

  Future<Either<ErrorModel, void>> call(int id) {
    return repository.deleteTaskType(id);
  }
}

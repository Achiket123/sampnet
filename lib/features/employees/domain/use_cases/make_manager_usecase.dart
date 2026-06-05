import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class MakeManagerUsecase {
  final EmployeesRepository repository;
  MakeManagerUsecase(this.repository);

  Future<Either<ErrorModel, void>> call({
    required int userId,
    required int organisationId,
    required String type,
    required String salary,
  }) {
    return repository.makeManager(
      userId: userId,
      organisationId: organisationId,
      type: type,
      salary: salary,
    );
  }
}
